export class MeleeWeapon extends Weapon
  new: (player, sprite, action, cooldown) =>
    super player, sprite, action
    @cooldown = cooldown
    @elapsed = cooldown

  update: (dt) =>
    @elapsed += dt
    super dt

  canUse: =>
    if @elapsed >= @cooldown
      @elapsed -= @cooldown
      return true
    return false
