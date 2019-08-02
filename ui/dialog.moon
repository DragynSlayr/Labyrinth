export class Dialog extends UIElement
  new: (text) =>
    super 0, 0, text, (Renderer\newFont 20)

    @textSpacing = 20
    @lineSpacing = 10
    @maxWidth = 400
    @lines = {}
    @calculateBounds!

    @enabled = true

  calculateBounds: =>
    padding = 2 * @textSpacing
    textWidth = @font\getWidth @text
    boxWidth = padding + textWidth
    if boxWidth < @maxWidth
      @width = boxWidth
      @height = padding + @font\getHeight!
      @lines = {@text}
    else
      @width = @maxWidth
      widthMax = @maxWidth - padding
      splitted = split @text, " "
      temp = ""
      i = 1
      added = false
      while i <= #splitted
        added = false
        old = temp
        temp ..= splitted[i] .. " "
        if (@font\getWidth temp) > widthMax
          table.insert @lines, old
          temp = splitted[i] .. " "
          added = true
        i += 1
      if not added
        table.insert @lines, temp
      @height = padding + (#@lines * @font\getHeight!) + ((#@lines - 1) * @lineSpacing)

    @x = Screen_Size.half_width - (@width / 2)
    @y = Screen_Size.height - (@height + 20)

  draw: =>
    if not @enabled return
    Camera\unset!
    setColor 0, 0, 0, 200
    love.graphics.rectangle "fill", @x, @y, @width, @height, 10, 10

    font = love.graphics.getFont!
    love.graphics.setFont @font
    setColor 255, 255, 255, 255
    for i, line in pairs @lines
      love.graphics.printf line, @x + @textSpacing, @y + @textSpacing + ((i - 1) * (@lineSpacing + @font\getHeight!)), @width, "left"
    love.graphics.setFont font
    Camera\set!
