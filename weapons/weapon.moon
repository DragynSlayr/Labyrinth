export class Weapon
  new: (player, sprite, action) =>
    @player = player
    @sprite = sprite
    @action = action
    @damage = 0

  mousepressed: (x, y, button, isTouch) =>
    if @canUse!
      @action x, y, button, isTouch

  update: (dt) =>
    @sprite\update dt

  canUse: =>
    return true

  draw: =>
    return
