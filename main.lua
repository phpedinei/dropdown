display.setDefault('background', 1, 0 , 0  )
local widget = require('widget')
local dropdown = require('dropdown')
local screen = require('screen')

local myDropdown

local dropdownOptions = {
  {
    title     = 'Go to Home',
    action    = function() 
      native.showAlert('Dropdown', 'Dropdown', {'Ok'})
    end 
  },
  {
    rightIcon = display.newImageRect('rightIcon.png', 32, 32),
    title     = 'Test',
    action    = function() 
      native.showAlert('Dropdown', 'Dropdown', {'Ok'})
    end 
  },
  {
    leftIcon  = display.newImageRect('star.png', 32, 32),
    rightIcon = display.newImageRect('rightIcon.png', 32, 32),
    title     = 'My favorite component',
    action    = function() 
      native.showAlert('Dropdown', 'Dropdown', {'Ok'})
    end 
  },
}

local button = widget.newButton{
  width       = 32,
  height      = 32,
  defaultFile = 'arrow.png',
  overFile    = 'arrow.png',
  onEvent     = function( event )
    local target = event.target
    local phase  = event.phase
    if phase == 'began' then
      target.alpha = .5
    else
      target.alpha = 1
      if phase ==  'ended' then
        myDropdown:toggle()
      end
    end
  end
}
button.alpha = .5

myDropdown     = dropdown.new{
  x            = screen.rightSide - 20,
  y            = screen.topSide + 100,
  toggleButton = button,
  width        = 280,
  marginTop    = 12,
  padding      = 20,
  options      = dropdownOptions
}

