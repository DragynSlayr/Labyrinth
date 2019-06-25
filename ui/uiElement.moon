export class UIElement
  new: (x, y, text = "", font = (Renderer\newFont 50)) =>
    @x = x
    @y = y
    @text = text
    @font = font
    @color = {0, 0, 0, 255}

  keypressed: (key, scancode, isrepeat) =>
    return

  keyreleased: (key) =>
    return

  mousepressed: (x, y, button, isTouch) =>
    return

  mousereleased: (x, y, button, isTouch) =>
    return

  textinput: (text) =>
    return

  focus: (focus) =>
    return

  update: (dt) =>
    return

  draw: =>
    Camera\unset!
    setColor @color[1], @color[2], @color[3], @color[4]
    font = love.graphics.getFont!
    love.graphics.setFont @font
    height = @font\getHeight!
    width = @font\getWidth @text
    love.graphics.printf @text, @x - (width / 2), @y - (height / 2), width, "center"
    love.graphics.setFont font
    Camera\set!
