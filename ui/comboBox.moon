export class ComboBox extends Button
  new: (x, y, width, height, options, font) =>
    max_width = 0
    max_idx = 1
    for k, v in pairs options
      option_width = font\getWidth v
      if option_width > max_width
        max_width = option_width
        max_idx = k
    super x, y, (max_width * 1.2) / Scale.width, height, options[max_idx], nil, font

    @options = options
    @open = false
    @option_height = @height

  onSelect: (x, y) =>
    if @open
      option = math.floor (((y - @y) / @option_height) + 1)
      @text = @options[option]
    @open = not @open

  isHovering: (x, y) =>
    height = @option_height
    if @open
      height *= #@options
    xOn = @x <= x and @x + @width >= x
    yOn = @y <= y and @y + height >= y
    return xOn and yOn

  mousereleased: (x, y, button, isTouch) =>
    if @active
      if button == 1
        selected = @isHovering x, y
        if selected and @selected
          @onSelect x, y
          @elapsed = 0
        else
          @open = false
        @selected = false

  draw: =>
    Camera\unset!
    if @active
      if @open
        for k, v in pairs @options
          y = @y + ((k - 1) * @option_height)
          if v == @text
            @idle_sprite\draw @x + (@width / 2), y + (@height / 2)
          else
            @hover_sprite\draw @x + (@width / 2), y + (@height / 2)
      else
        if @sprited
          if @selected
            @hover_sprite\draw @x + (@width / 2), @y + (@height / 2)
          else
            @idle_sprite\draw @x + (@width / 2), @y + (@height / 2)
        else
          if @selected
            setColor @hover_color\get!
          else
            setColor @idle_color\get!
          love.graphics.rectangle "fill", @x, @y, @width, @height
    else
      setColor 127, 127, 127, 255
      love.graphics.rectangle "fill", @x, @y, @width, @height

    font = love.graphics.getFont!

    love.graphics.setFont @font
    setColor 0, 0, 0
    height = @font\getHeight!

    if @open
      for k, v in pairs @options
        love.graphics.printf v, @x, @y + ((@height - height) / 2) + ((k - 1) * @option_height), @width, "center"
    else
      love.graphics.printf @text, @x, @y + ((@height - height) / 2), @width, "center"

    love.graphics.setFont font

    Camera\set!
