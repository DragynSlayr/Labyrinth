export class TextBox extends UIElement
  new: (x, y, width, height) =>
    super x, y
    @width = width
    @height = height
    @color = {0, 0, 0, 127}
    @text_color = {0, 255, 0, 255}
    @font = love.graphics.newFont 20
    @elapsed = 0

    @has_character_limit = false
    @character_limit = 0

    @cursor = {}
    @cursor.alpha = 255
    @cursor.on_time = 0.33
    @cursor.off_time = 0.33
    @cursor.is_on = true
    @cursor.position = Point 0, 0

    @active = true
    @selected = false

    @hold_timer = 0
    @hold_delay = 1 / 30
    @holding_back = false
    @delay_timer = 0
    @max_delay = 1
    @repeating = false

    @resetText!

    @action = {}
    @action["tab"] = () ->
      if not @lines[@lines_index]
        @lines[@lines_index] = {}
      for i = 1, 4
        @char_index += 1
        table.insert @lines[@lines_index], @char_index, " "

    @action["return"] = () ->
      @lines_index += 1
      table.insert @lines, @lines_index, {}
      @char_index = 1

    @action["up"] = () ->
      if @lines_index > 1
        @lines_index -= 1
        @char_index = #@lines[@lines_index]

    @action["down"] = () ->
      if @lines_index < #@lines
        @lines_index += 1
        @char_index = #@lines[@lines_index]

    @action["left"] = () ->
      if @char_index > 1
        @char_index -= 1

    @action["right"] = () ->
      if @lines[@lines_index]
        if @char_index < #@lines[@lines_index]
          @char_index += 1

  resetText: =>
    @lines = {{}}
    @lines_index = 1
    @char_index = 1

  addText: (word, replace_text = "") =>
    remove_len = #replace_text
    start = @char_index
    @char_index -= (3 + remove_len)
    if @char_index < 1
      @char_index = 1
    adjusted = @char_index
    for i = 1, #word
      letter = string.sub word, i, i
      @lines[@lines_index][@char_index] = letter
      @char_index += 1
    @char_index -= 1

  getText: =>
    s = ""
    for k, v in pairs @lines
      for k2, v2 in pairs v
        s ..= v2
      if k ~= #@lines
        s ..= "\n"
    return s

  getLine: (idx, idx2 = #@lines[idx]) =>
    s = ""
    if @lines[idx]
      for k, v in pairs @lines[idx]
        if k < idx2 + 1
          s ..= v
    return s

  textinput: (text) =>
    if @active
      if text ~= '`'
        if not @lines[@lines_index]
          @lines[@lines_index] = {}
        current_line = @getLine @lines_index
        current_line ..= text
        width = (@font\getWidth current_line) * Scale.width
        if width + (30 * Scale.width) <= @width or (@has_character_limit and #current_line < @character_limit + 1)
          @char_index += 1
          table.insert @lines[@lines_index], @char_index, text

  keypressed: (key, scancode, isrepeat) =>
    if @active
      if key == "backspace"
        @holding_back = true
        if #@lines[@lines_index] ~= 0
          if @char_index > 0
            table.remove @lines[@lines_index], @char_index
            @char_index -= 1
        else
          if @lines_index > 1
            @lines_index -= 1
            @char_index = #@lines[@lines_index]
      else
        if @action[key]
          @action[key]!

  keyreleased: (key) =>
    if key == "backspace"
      @holding_back = false
      @repeating = false

  isHovering: (x, y) =>
    xOn = @x <= x and @x + @width >= x
    yOn = @y <= y and @y + @height >= y
    return xOn and yOn

  mousepressed: (x, y, button, isTouch) =>
    if button == 1
      @selected = @isHovering x, y

  mousereleased: (x, y, button, isTouch) =>
    if button == 1
      selected = @isHovering x, y
      if selected and @selected
        @active = true
      else
        @active = false
      @selected = false

  update: (dt) =>
    if @active
      if @holding_back
        @delay_timer += dt
        if @delay_timer >= @max_delay
          @delay_timer = 0
          @repeating = true
      if @repeating
        @hold_timer += dt
        if @hold_timer >= @hold_delay
          if love.keyboard.isDown "backspace"
            @hold_timer = 0
            if #@lines[@lines_index] ~= 0
              if @char_index > 0
                table.remove @lines[@lines_index], @char_index
                @char_index -= 1
            else
              if @lines_index > 1
                @lines_index -= 1
                @char_index = #@lines[@lines_index]

    @elapsed += dt
    if @cursor.is_on
      if @elapsed >= @cursor.on_time
        @elapsed = 0
        @cursor.alpha = 0
        @cursor.is_on = false
    else
      if @elapsed >= @cursor.off_time
        @elapsed = 0
        @cursor.alpha = 255
        @cursor.is_on = true

    height = @font\getHeight!
    width = 0
    if @lines[@lines_index]
      width = @font\getWidth (@getLine @lines_index, @char_index)
    @cursor.position = Point @x + (10 * Scale.width) + width, @y + (height / 2) + ((@lines_index - 1) * height)

  draw: =>
    Camera\unset!

    setColor @color[1], @color[2], @color[3], @color[4]
    love.graphics.rectangle "fill", @x, @y, @width, @height

    text = @getText!

    setColor @text_color[1], @text_color[2], @text_color[3], @text_color[4]
    height = @font\getHeight!-- * Scale.height
    width = @font\getWidth (@getLine @lines_index, @char_index)
    --width = (@font\getWidth text) * Scale.width
    font = love.graphics.getFont!
    love.graphics.setFont @font--(love.graphics.newFont height)
    love.graphics.printf text, @x + (10 * Scale.width), @y + (height / 2), @width, "left"
    love.graphics.setFont font

    @cursor.position = Point @x + (12 * Scale.width) + width, @y + (height / 2) + ((@lines_index - 1) * height)

    if @active
      setColor @text_color[1], @text_color[2], @text_color[3], @cursor.alpha
      love.graphics.rectangle "fill", @cursor.position.x, @cursor.position.y, 10 * Scale.width, height

    Camera\set!
