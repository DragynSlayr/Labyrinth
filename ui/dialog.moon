export class Dialog extends UIElement
  new: (text) =>
    super 0, 0, text
    @width = 400
    @height = 200
    @x = Screen_Size.half_width - (@width / 2)
    @y = Screen_Size.height - (@height + 20)
    @enabled = true

  draw: =>
    if not @enabled return
    Camera\unset!
    setColor 0, 0, 0, 120
    love.graphics.rectangle "fill", @x, @y, @width, @height, 10, 10

    font = love.graphics.getFont!
    love.graphics.setFont @font
    -- love.graphics.printf @text, @x - (width / 2), @y - (height / 2), width, "center"
    love.graphics.setFont font
    Camera\set!
