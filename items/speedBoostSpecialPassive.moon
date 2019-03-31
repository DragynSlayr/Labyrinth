export class SpeedBoostSpecialPassive extends PassiveItem
  @lowest_rarity = 5
  new: (rarity) =>
    @rarity = rarity
    sprite = Sprite "item/speedBoostSpecial.tga", 32, 32, 1, 1.75
    effect = (player) =>
      filters = {EntityTypes.enemy, EntityTypes.boss}
      boost = 0
      for k2, filter in pairs filters
        for k, v in pairs Driver.objects[filter]
          enemy = v\getHitBox!
          p = player\getHitBox!
          p.radius += player.attack_range + player.range_boost
          if enemy\contains p
            boost += player.max_speed / 4
      player.speed_boost = math.min boost, player.max_speed
    super sprite, 0, effect
    @name = "Scaredy Cat"
    @description = "Speed increase for every close enemy"
