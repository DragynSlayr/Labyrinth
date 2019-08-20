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

  addButtons: (idx, buttons) =>
    box = @boxes[idx]
    box.hasButtons = true
    box.shouldGoNext = false
    box.buttons = {}
    box.buttons.x = box.x + box.width + 10
    box.buttons.height = (1 * @textSpacing) + (#buttons * @font\getHeight!) + ((#buttons - 1) * @lineSpacing)
    box.buttons.y = box.y
    if box.buttons.y + box.buttons.height >= Screen_Size.height
      box.buttons.y -= (box.buttons.y + box.buttons.height - Screen_Size.height) + @lineSpacing
    box.buttons.buttons = {}
    width = 0
    for k, button in pairs buttons
      box.buttons.buttons[k] = {}
      box.buttons.buttons[k].text = button[1]
      box.buttons.buttons[k].action = button[2]
      box.buttons.buttons[k].lit = false
      box.buttons.buttons[k].selected = false
      temp = @font\getWidth button[1]
      if temp > width
        width = temp
    box.buttons.width = width + (2 * @textSpacing)

  updateBox: (text, name = "...") =>
    @texts = text
    @name = name
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
      @boxes[i].shouldGoNext = true

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

  goToNext: =>
    @idx += 1
    @elapsed = 0
    @canClick = false
    if @idx > #@boxes
      @enabled = false
      @doneAction @

  isHovering: (x, y) =>
    box = @boxes[@idx]
    xOn = box.x <= x and box.x + box.width >= x
    yOn = box.y <= y and box.y + box.height >= y
    return xOn and yOn

  mousepressed: (x, y, button, isTouch) =>
    if @canClick and button == 1
      @selected = @isHovering x, y

      box = @boxes[@idx]
      if box.hasButtons
        for k, button in pairs box.buttons.buttons
          button.selected = button.lit

  mousereleased: (x, y, button, isTouch) =>
    if @canClick and button == 1
      box = @boxes[@idx]

      passThrough = true
      if @selected and (@isHovering x, y)
        if box.shouldGoNext
          @goToNext!
          passThrough = false
      @selected = false

      if box.hasButtons and passThrough
        for k, button in pairs box.buttons.buttons
          if button.selected and button.lit
            button.action @
          button.selected = false

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
    else
      @checkButtonHovering!

  checkButtonHovering: =>
    box = @boxes[@idx]
    if box.hasButtons
      buttons = box.buttons
      x, y = love.mouse.getPosition!
      xOn = buttons.x <= x and buttons.x + buttons.width >= x
      yOn = buttons.y <= y and buttons.y + buttons.height >= y
      if xOn and yOn
        deg =(y - buttons.y) / buttons.height
        region = (math.floor (deg * #box.buttons.buttons)) + 1
        for k, button in pairs box.buttons.buttons
          yOn = buttons.y <= y and buttons.y + buttons.height >= y
          button.lit = k == region
      else
        for k, button in pairs box.buttons.buttons
          button.lit = false

  draw: =>
    if not @enabled return
    Camera\unset!

    box = @boxes[@idx]

    setColor 0, 0, 0, 200
    love.graphics.rectangle "fill", box.x, box.y, box.width, box.height, 10, 10
    love.graphics.setLineWidth 3
    setColor 150, 150, 150, 255
    love.graphics.rectangle "line", box.x, box.y, box.width, box.height, 10, 10
    love.graphics.setLineWidth 1

    font = love.graphics.getFont!
    love.graphics.setFont @font
    width = love.graphics.getFont!\getWidth @name
    height = love.graphics.getFont!\getHeight!

    setColor 0, 0, 0, 200
    love.graphics.rectangle "fill", box.x + 6, box.y - 15, width + 10, height + 4, 3, 3
    love.graphics.setLineWidth 2
    setColor 150, 150, 150, 255
    love.graphics.rectangle "line", box.x + 6, box.y - 15, width + 10, height + 4, 3, 3
    love.graphics.setLineWidth 1
    setColor 255, 255, 255, 255
    love.graphics.printf @name, box.x + 11, box.y - 13, width, "center"

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

    if box.hasButtons and @canClick
      buttons = box.buttons
      setColor 0, 0, 0, 200
      love.graphics.rectangle "fill", buttons.x, buttons.y, buttons.width, buttons.height, 10, 10
      love.graphics.setLineWidth 3
      setColor 150, 150, 150, 255
      love.graphics.rectangle "line", buttons.x, buttons.y, buttons.width, buttons.height, 10, 10
      love.graphics.setLineWidth 1

      buttons2 = box.buttons.buttons
      for k, button in pairs buttons2
        if button.lit
          setColor 127, 127, 127, 127
          fontHeight = @font\getHeight!
          y = buttons.y + (0.5 * @textSpacing) + ((k - 1) * (@lineSpacing + @font\getHeight!))
          love.graphics.rectangle "fill", buttons.x + 5, y - 2, buttons.width - 10, fontHeight + 4, 3, 3
        setColor 255, 255, 255, 255
        love.graphics.printf button.text, buttons.x + @textSpacing, buttons.y + (0.5 * @textSpacing) + ((k - 1) * (@lineSpacing + @font\getHeight!)), buttons.width, "left"

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
