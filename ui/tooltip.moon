export class Tooltip extends Text
  new: (x, y, textFunc, font, alignment = "left") =>
    @textFunc = textFunc
    super x, y, @textFunc!, font
    @enabled = false
    @alignment = alignment

  update: (dt) =>
    @text = @textFunc!

  draw: =>
    if @enabled
      love.graphics.push "all"
      setColor @color[1], @color[2], @color[3], @color[4]
      love.graphics.setFont @font
      height = @font\getHeight!
      width = @font\getWidth @text
      love.graphics.printf @text, @x, @y - (height / 2), width, @alignment
      love.graphics.pop!
