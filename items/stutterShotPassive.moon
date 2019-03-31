export class StutterShotPassive extends PassiveItem
  new: (rarity) =>
    @rarity = rarity
    sprite = Sprite "item/stutterShotPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      @delay = math.random!
      filters = {EntityTypes.enemy, EntityTypes.boss}
      if not (tableContains filters, EntityTypes.goal)
        for k, v in pairs Driver.objects[EntityTypes.goal]
          if v.goal_type == GoalTypes.attack
            table.insert filters, EntityTypes.goal
            break
      bullet_speed = Vector 0, 0
      if love.keyboard.isDown Controls.keys.SHOOT_LEFT
        bullet_speed\add (Vector -player.bullet_speed, 0)
      if love.keyboard.isDown Controls.keys.SHOOT_RIGHT
        bullet_speed\add (Vector player.bullet_speed, 0)
      if love.keyboard.isDown Controls.keys.SHOOT_UP
        bullet_speed\add (Vector 0, -player.bullet_speed)
      if love.keyboard.isDown Controls.keys.SHOOT_DOWN
        bullet_speed\add (Vector 0, player.bullet_speed)
      if bullet_speed\getLength! > 0
        bullet = FilteredBullet player.position.x, player.position.y, player.damage * @damage_multiplier, bullet_speed, filters
        bullet.sprite = Sprite "projectile/doubleShot.tga", 26, 20, 1, 1
        bullet.max_dist = @getHitBox!.radius + (2 * (player.attack_range + player.range_boost))
        if player.knocking_back
          bullet.knockback = true
        Driver\addObject bullet, EntityTypes.bullet
    super sprite, 0, effect
    @name = "Stutter"
    @description = "Random burst of bullets"
    @damage_multiplier = ({1.0, 1.1, 1.2, 1.3, 1.4})[@rarity]

  getStats: =>
    stats = super!
    table.insert stats, "Damage Multiplier: " .. @damage_multiplier
    return stats
