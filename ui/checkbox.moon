export class CheckBox extends Button

  new: (x, y, size, action, font) =>
    super x, y, size, size, "", action, font

    @checked = false

    @idle_sprite = Sprite "ui/checkbox/idle.tga", 32, 32, 1, 1
    @hover_sprite = Sprite "ui/checkbox/hover.tga", 32, 32, 1, 1
    @checked_sprite = Sprite "ui/checkbox/checked.tga", 28, 28, 1, 0.9

  mousereleased: (x, y, button, isTouch) =>
    if @active
      if button == 1
        selected = @isHovering x, y
        if selected and @selected
          @checked = not @checked
          @elapsed = 0
        @selected = false

  update: (dt) =>
    @idle_sprite\update dt
    @hover_sprite\update dt
    @checked_sprite\update dt

  draw: =>
    Camera\unset!
    if @active
      shift_x = @x + (@width / 2)
      shift_y = @y + (@height / 2)
      if @selected or @checked
        @hover_sprite\draw shift_x, shift_y
      else
        @idle_sprite\draw shift_x, shift_y
      if @checked
        @checked_sprite\draw shift_x, shift_y
    else
      setColor 127, 127, 127, 255
      love.graphics.rectangle "fill", @x, @y, @width, @height
    Camera\set!
