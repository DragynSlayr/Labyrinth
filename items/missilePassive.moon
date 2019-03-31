export class MissilePassive extends PassiveItem
  @lowest_rarity = 5
  new: (rarity) =>
    @rarity = rarity
    sprite = Sprite "item/missilePassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      missile = Missile player.position.x, player.position.y
      Driver\addObject missile, EntityTypes.bullet
    super sprite, 5.5, effect
    @name = "Gonna Get You"
    @description = "A homing missile spawns periodically"
