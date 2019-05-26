export class DoubleShotPassive extends PassiveItem
  new: (rarity) =>
    @rarity = rarity
    @damage_multiplier = ({0.5, 0.6, 0.7, 0.8, 0.9})[@rarity]
    sprite = Sprite "item/doubleShotPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      filters = {EntityTypes.enemy, EntityTypes.boss}
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
        bullet.sprite = Sprite "projectile/doubleShot.tga", 26, 20, 1, 0.5
        bullet.max_dist = @getHitBox!.radius + (2 * (player.attack_range + player.range_boost))
        if player.knocking_back
          bullet.knockback = true
        Driver\addObject bullet, EntityTypes.bullet
    super sprite, 0, effect
    @name = "Another One"
    @description = "Shoot an extra bullet"

  getStats: =>
    stats = super!
    table.insert stats, "Damage Multiplier: " .. @damage_multiplier
    return stats

  pickup: (player) =>
    super player
    @delay = player.attack_speed
