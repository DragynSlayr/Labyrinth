export class DamageReflectPassive extends PassiveItem
  @lowest_rarity = 2
  @highest_rarity = 4
  new: (rarity) =>
    @rarity = rarity
    @chance = ({50, 55, 60, 65, 70})[@rarity]
    sprite = Sprite "item/damageReflectPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      health = player.health
      if health < @last_health
        difference = @last_health - health
        @last_health = health
        if math.random! >= ((100 - @chance) / 100)
          num_bullets = (math.ceil difference) * 20
          pos = player.position\getCopy!
          filters = {EntityTypes.enemy, EntityTypes.boss}
          angle = (2 * math.pi) / (num_bullets + 1)
          bullet_speed = Vector 0, 150
          for i = 1, num_bullets
            bullet = FilteredBullet pos.x, pos.y, 0.5, bullet_speed, filters
            bullet_speed\rotate angle
    super sprite, 0, effect
    @name = "Vary Parry"
    @description = "Has a chance to reflect damage taken"

  getStats: =>
    stats = super!
    table.insert stats, "Reflect Chance: " .. @chance .. "%"
    return stats

  pickup: (player) =>
    super player
    @last_health = player.health + player.armor
