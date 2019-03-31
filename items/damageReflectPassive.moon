export class DamageReflectPassive extends PassiveItem
  @lowest_rarity = 2
  @highest_rarity = 4
  new: (rarity) =>
    @rarity = rarity
    @chance = ({50, 55, 60, 65, 70})[@rarity]
    sprite = Sprite "item/damageReflectPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      health = player.health + player.armor
      if health < @last_health
        difference = @last_health - health
        if math.random! >= ((100 - @chance) / 100)
          num_bullets = (math.ceil difference) * 10
          x, y = player.position\getComponents!
          filters = {EntityTypes.enemy, EntityTypes.boss}
          range = player\getHitBox!.radius + (3 * (player.attack_range + player.range_boost))
          angle = (2 * math.pi) / (num_bullets + 1)
          bullet_speed = Vector 0, 1, true
          for i = 1, num_bullets
            speed = bullet_speed\multiply player.bullet_speed
            bullet = FilteredBullet x, y, player.damage, speed, filters
            bullet.max_dist = range
            Driver\addObject bullet, EntityTypes.bullet
            bullet_speed\rotate angle
      @last_health = health
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
