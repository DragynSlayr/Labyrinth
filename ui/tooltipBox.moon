export class TooltipBox extends Tooltip
  new: (x, y, width, height, textFunc, alignment = "center") =>
    super x, y, textFunc, nil, alignment
    @width = width
    @height = height
    @font = Renderer\newFont @height
    @elapsed = 0
    @box_color = {255, 215, 0}
    @alpha = 0
    @speed = 3
    @blocked = false

  update: (dt) =>
    super dt
    @elapsed += dt * @speed
    num = ((math.sin @elapsed) + 1) / 2
    @alpha = math.ceil num * 255

  draw: =>
    if @enabled and not @blocked
      x = @x - (@width / 2)
      y = @y - (@height / 2)
      setColor @box_color[1], @box_color[2], @box_color[3], @alpha
      love.graphics.rectangle "fill", x, y, @width, @height
      setColor @color[1], @color[2], @color[3], @color[4]
      font = love.graphics.getFont!
      love.graphics.setFont @font
      love.graphics.printf @text, x, @y - (@font\getHeight! / 2), @width, @alignment
      love.graphics.setFont font
