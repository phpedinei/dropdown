local screen = require('screen')
local widget = require('widget')
local Dropdown = {}


local function onRowRender( event )
  local row        = event.row
  local rowHeight  = row.contentHeight
  local rowWidth   = row.contentWidth
  local title      = row.params.title
  local leftIcon   = row.params.leftIcon or nil
  local rightIcon  = row.params.rightIcon or nil
  local titleColor = row.params.titleColor or {0,0,0}

  local options = {
      parent   = row,
      text     = title,    
      x        = 20,
      y        = rowHeight * .5,
      width    = rowWidth,
      font     = native.systemFont,   
      fontSize = 14,
      align    = 'left'
  }

  local title   = display.newText( options )
  title.anchorX = 0
  title:setFillColor( titleColor )

  if leftIcon then 
    leftIcon.anchorX = 0
    leftIcon.x, leftIcon.y = leftIcon.width * .5 - 14, rowHeight * .5
    title.x = leftIcon.width + 10
    row:insert( leftIcon )
  end

  if rightIcon then
    rightIcon.anchorX = 0
    rightIcon.x, rightIcon.y = rowWidth - rightIcon.width * .5 - 14, rowHeight * .5
    row:insert( rightIcon )
  end

end


local function onRowTouch(event)
  local row   = event.target
  local phase = event.phase

  if phase == 'release' then
    row.params._group:hide(0.001)
    row.params.action()
  end

  return true
end


local function createTable( options, width, height, group )
  
  local tableView = widget.newTableView{
      x = 0,
      y = 0,
      width  = width,
      height = height,
      hideBackground = false,
      rowTouchDelay = 0,
      onRowRender = onRowRender,
      onRowTouch = onRowTouch
  }

  for i=1, #options  do 
      local option = options[i]
      option._group = group
      tableView:insertRow{
        rowHeight  = 44,
        isCategory = false,
        params = option
      }
  end

  return tableView
end

function Dropdown.new( o )
  o = o or {}

  local height      = o.height     or nil
  local width       = o.width      or 144
  local x           = o.x          or 100
  local y           = o.y          or 100
  local isOverlay   = o.isOverlay  or false
  local marginTop   = o.marginTop  or 10
  local padding     = o.padding    or 10
  local options     = o.options    or {}
  local button      = o.toggleButton     or error('Invalid toggle button')

  local group     = display.newGroup()
  local overlay   = display.newRect( group, 0, 0, screen.totalWidth, screen.totalHeight )
  overlay:setFillColor( 0, 0, 0, .3 )
  overlay.x, overlay.y = screen.centerX, screen.centerY

  overlay.touch = function( self, e )
    local phase = e.phase 
    if phase == 'ended' then
        group:hide()
    end
    return true
  end 

  overlay:addEventListener( 'touch', overlay )
  overlay.isVisible = false

  button.x, button.y = x, y
  group:insert( button )
  if not height then
    height = 44 * #options + padding
  end
  local container = display.newContainer( width, height )
  container.x, container.y = x + 10, y + 10 + marginTop
  container.anchorX, container.anchorY = 1, 0
  group:insert( container )

  local groupMove = display.newGroup( )
  container:insert( groupMove )
  group.move = groupMove
  groupMove.y = height * -1

  local background = display.newRect( 0, 0, width, height )
  groupMove:insert( background )

  local table = createTable( options, width - padding, height - padding, group )
  groupMove:insert( table )

  function group:show()
    local move = self.move
    transition.to( move, { y = 0, time =  time or 100, transition = easing.outQuad } )
    self.isShow = true
    overlay.isVisible = true
  end

  function group:hide( time )
    local move = self.move
    transition.to( move, { y = height * -1, time = time or 100, transition = easing.outQuad } )
    self.isShow = false
    overlay.isVisible = false
  end 

  function group:toggle( time )
    if self.isShow then 
        self:hide( time )
    else 
        self:show( time )
    end
  end
  
  return group
end



return Dropdown