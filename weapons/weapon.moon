export class Weapon
  new: (player, sprite, action) =>
    @player = player
    @sprite = sprite
    @action = action
    @damage = 0
    @used = false

  mousepressed: (x, y, button, isTouch) =>
    if @canUse!
      @action x, y, button, isTouch

  update: (dt) =>
    @sprite\update dt

  canUse: =>
    return not @used

  draw: =>
    return
