export class Weapon
  new: (player, sprite) =>
    @player = player
    @sprite = sprite
    @damage = 0
    @used = false

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
      @sprite\draw @player.position.x, @player.position.y
