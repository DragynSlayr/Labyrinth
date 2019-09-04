export class DebugMenu
  new: =>
    export DEBUG_MENU_ENABLED = true
    export DEBUG_MENU = false
    export DEBUGGING = false
    export SHOW_RANGE = false

    @completer = AutoComplete!

    @ui_objects = {}
    @createMenu!

  createMenu: =>
    bg = Background {0, 0, 0, 127}
    @add bg

    x = Screen_Size.width - (135 * Scale.width)
    y = Screen_Size.height - (40 * Scale.height)
    back_button = Button x, y, 250, 60, "Back", () ->
      export DEBUG_MENU = false
    @add back_button

    width = Screen_Size.width - (20 * Scale.width)
    height = Screen_Size.height - (95 * Scale.height)
    text_box = DebugTextBox 10 * Scale.width, 10 * Scale.height, width, height
    @add text_box

    @completer.text_box = text_box

    x = 135 * Scale.width
    y = Screen_Size.height - (40 * Scale.height)
    run_button = Button x, y, 250, 60, "Run", () ->
      text_box\runText!
      @completer.text = ""
      @completer.last_text = " "
      @completer.words = {}
    @add run_button

  add: (object) =>
    table.insert @ui_objects, object

  keypressed: (key, scancode, isrepeat) =>
    for k, v in pairs @ui_objects
      v\keypressed key, scancode, isrepeat
    @completer\keypressed key, scancode, isrepeat

  keyreleased: (key) =>
    for k, v in pairs @ui_objects
      v\keyreleased key

  mousepressed: (x, y, button, isTouch) =>
    for k, v in pairs @ui_objects
      v\mousepressed x, y, button, isTouch

  mousereleased: (x, y, button, isTouch) =>
    for k, v in pairs @ui_objects
      v\mousereleased x, y, button, isTouch

  textinput: (text) =>
    for k, v in pairs @ui_objects
      v\textinput text
    @completer\textinput text

  update: (dt) =>
    for k, v in pairs @ui_objects
      v\update dt
    @completer\update dt

  draw: =>
    Camera\unset!
    for k, v in pairs @ui_objects
      v\draw!
    @completer\draw!
    Camera\set!
