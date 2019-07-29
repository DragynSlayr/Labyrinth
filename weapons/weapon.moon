export class Weapon
  new: (player, sprite) =>
    @player = player
    @sprite = sprite
    @used = false
    @sprite_color = @sprite.color
    x_scale = (@player.sprite.scaled_width / @sprite.width) / Scale.width
    y_scale = (@player.sprite.scaled_height / @sprite.height) / Scale.height
    @sprite\setScale (x_scale * 0.75), (y_scale * 0.75)
    @updateDamage!

  calcDamage: =>
    return 0

  updateDamage: =>
    @damage = @calcDamage!

  action: (x, y, button, isTouch) =>
    return

  mousepressed: (x, y, button, isTouch) =>
    if @canUse!
      @action x, y, button, isTouch

  mousereleased: (x, y, button, isTouch) =>
    return

  update: (dt) =>
    @sprite\update dt

  canUse: =>
    return not @used

  draw: =>
    if @used
      @sprite.color = {0, 0, 0, 150}
    else
      @sprite.color = @sprite_color

    Camera\unset!
    love.graphics.setLineWidth 5
    setColor 0, 0, 0, 255
    love.graphics.rectangle "line", 10, 10, 60, 60
    setColor 139, 69, 19, 255
    love.graphics.rectangle "fill", 10, 10, 60, 60
    @sprite\draw 40, 40
    love.graphics.setLineWidth 1
    Camera\set!
