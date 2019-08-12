export class Dialog extends UIElement
  new: (text = nil) =>
    super 0, 0, "", (Renderer\newFont 20)

    @textSpacing = 20
    @lineSpacing = 10
    @maxWidth = 400

    if not text or #text == 0
      @enabled = false
    else
      @updateBox text

    @doneAction = (dialog) =>
      -- dialog\updateBox {"Endless Loop"}
      return

  updateBox: (text) =>
    @texts = text
    @boxes = {}
    for i, text in pairs @texts
      @text = text
      @lines = {}
      @calculateBounds!

      @boxes[i] = {}
      @boxes[i].x = @x
      @boxes[i].y = @y
      @boxes[i].width = @width
      @boxes[i].height = @height
      @boxes[i].lines = @lines
      @boxes[i].numChars = @countChars @boxes[i].lines
      @boxes[i].textSpeed = @boxes[i].numChars / 2

    @enabled = true
    @selected = false
    @elapsed = 0
    @idx = 1

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
      while i <= #splitted
        old = temp
        temp ..= splitted[i] .. " "
        if (@font\getWidth temp) > widthMax
          table.insert @lines, (strip old)
          temp = splitted[i] .. " "
        i += 1
      if #(strip temp) > 0
        table.insert @lines, (strip temp)
      @height = padding + (#@lines * @font\getHeight!) + ((#@lines - 1) * @lineSpacing)

    @x = Screen_Size.half_width - (@width / 2)
    @y = Screen_Size.height - (@height + 20)

  isHovering: (x, y) =>
    box = @boxes[@idx]
    xOn = box.x <= x and box.x + box.width >= x
    yOn = box.y <= y and box.y + box.height >= y
    return xOn and yOn

  mousepressed: (x, y, button, isTouch) =>
    if @canClick and button == 1
      @selected = @isHovering x, y

  mousereleased: (x, y, button, isTouch) =>
    if @canClick and button == 1
      if @selected and (@isHovering x, y)
        @idx += 1
        @elapsed = 0
        @canClick = false
        if @idx > #@boxes
          @enabled = false
          @doneAction @
      @selected = false

  countChars: (texts) =>
    sum = 0
    for i, text in pairs texts
      sum += #text
    return sum

  update: (dt) =>
    if not @enabled return
    if not @canClick
      box = @boxes[@idx]
      @elapsed += dt * box.textSpeed
      if @elapsed >= box.numChars
        @canClick = true

  draw: =>
    if not @enabled return
    Camera\unset!

    box = @boxes[@idx]

    setColor 0, 0, 0, 200
    love.graphics.rectangle "fill", box.x, box.y, box.width, box.height, 10, 10

    font = love.graphics.getFont!
    love.graphics.setFont @font
    setColor 255, 255, 255, 255
    lines = box.lines
    toDraw = math.ceil @elapsed
    for i, line in pairs lines
      if #line >= toDraw
        line = string.sub line, 1, toDraw
      toDraw -= #line
      love.graphics.printf line, box.x + @textSpacing, box.y + @textSpacing + ((i - 1) * (@lineSpacing + @font\getHeight!)), box.width, "left"
      if toDraw <= 0
        break

    if @canClick
      edgeX = box.x + box.width
      edgeY = box.y + box.height
      if (math.cos (Driver.elapsed * 3 * math.pi)) >= 0
        if @idx != #@boxes
          vertices = {edgeX - 15, edgeY - 15, edgeX - 5, edgeY - 15, edgeX - 10, edgeY - 10}
          love.graphics.polygon 'fill', vertices
        else
          love.graphics.rectangle 'fill', edgeX - 15, edgeY - 15, 5, 5

    love.graphics.setFont font
    Camera\set!
