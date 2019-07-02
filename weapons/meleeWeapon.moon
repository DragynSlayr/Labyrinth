export class MeleeWeapon extends Weapon
  new: (player, sprite, action, cooldown) =>
    super player, sprite, action
    @cooldown = cooldown
