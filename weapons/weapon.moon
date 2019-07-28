export class Weapon
  new: (player, sprite) =>
    @player = player
    @sprite = sprite
    @damage = 0
    @used = false
    @sprite_color = @sprite.color
    @sprite_color[4] = 150
    x_scale = (@player.sprite.scaled_width / @sprite.width) / Scale.width
    y_scale = (@player.sprite.scaled_height / @sprite.height) / Scale.height
    @sprite\setScale x_scale, y_scale

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
    @sprite\draw @player.position.x, @player.position.y
