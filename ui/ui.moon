-- Class for handling UI elements
export class UIHandler
  new: =>
    -- List of elements of the GUI
    @screens = {}
    @current_screen = Screen_State.none
    @state_stack = Stack!
    @state_stack\add Screen_State.main_menu

    for k, v in pairs Screen_State
      @screens[v] = {}

  -- Add an element to the GUI
  add: (element, screen = @current_screen) =>
    @screens[screen][#@screens[screen] + 1] = element

  set_screen: (new_screen) =>
    @current_screen = new_screen

  filter: (typeof, layer = @current_screen) =>
    elements = {}
    for k, v in pairs @screens[layer]
      if v.__class == typeof.__class
        table.insert elements, v
    return elements

  keypressed: (key, scancode, isrepeat) =>
    for k, v in pairs @screens[@current_screen]
      v\keypressed key, scancode, isrepeat

  keyreleased: (key) =>
    for k, v in pairs @screens[@current_screen]
      v\keyreleased key

  mousepressed: (x, y, button, isTouch) =>
    for k, v in pairs @screens[@current_screen]
      v\mousepressed x, y, button, isTouch

  mousereleased: (x, y, button, isTouch) =>
    for k, v in pairs @screens[@current_screen]
      v\mousereleased x, y, button, isTouch

  textinput: (text) =>
    for k, v in pairs @screens[@current_screen]
      v\textinput text

  focus: (focus) =>
    for k, v in pairs @screens[@current_screen]
      v\focus focus

  -- Update all the elements of the GUI
  -- dt: Time since last update
  update: (dt) =>
    for k, v in pairs @screens[@current_screen]
      v\update dt

  -- Draw the GUI elements
  draw: (included = {}) =>
    for k, v in pairs @screens[@current_screen]
      if #included == 0 or (tableContains included, v.__class)
        v\draw!
