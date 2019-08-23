export class ControlsHandler extends Screen
  new: =>
    contents, _ = love.filesystem.read "SETTINGS"
    lines = split contents, "\n"

    idx = -1
    for k, v in pairs lines
      if (string.sub v, 1, 7) == "MOVE_UP"
        idx = k
        break

    @keys = {}
    @key_names = {}

    for i = idx, #lines
      line = split lines[i], " "
      @keys[line[1]] = line[2]
      if #line[1] > 0
        table.insert @key_names, line[1]

    @selected = ""
    @button = nil
    @selected_text = ""

  keyreleased: (key) =>
    if @selected ~= ""
      if key ~= "backspace"
        @keys[@key_names[@selected]] = key
        @button.text = key
        writeKey @key_names[@selected], key
        export KEY_CHANGED = true
      @button.selected = false
      @button = nil
      @selected_text = ""

  draw: =>
    if @selected ~= "" and @button
      @button.selected = true
      Camera\unset!
      font = love.graphics.getFont!
      love.graphics.setFont (Renderer\newFont 30)
      setColor 0, 0, 0, 255
      text = "Press a button for " .. @selected_text .. " or 'Backspace' to cancel"
      love.graphics.printf text, 0, Screen_Size.height * 0.835, Screen_Size.width, "center"
      love.graphics.setFont font
      Camera\set!
