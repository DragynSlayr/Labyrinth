export class Background extends UIElement
  new: (color) =>
    super 0, 0, ""
    @color = color

  setSprite: (sprite) =>
    @sprite = sprite

  draw: =>
    if @sprite
      @sprite\draw Screen_Size.half_width, Screen_Size.half_height
    else
      setColor @color[1], @color[2], @color[3], @color[4]
      love.graphics.rectangle "fill", 0, 0, Screen_Size.width, Screen_Size.height
