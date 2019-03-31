export class SplitShot extends LinearProjectile
  new: (x, y, speed, dist, sprite) =>
    super x, y, speed, dist, sprite
    @depth = 1
    @max_depth = 2
    @dist = dist
    @block_rotation = false
    @target = Jitter @target.position.x, @target.position.y
    Driver\addObject @target, EntityTypes.background

  kill: =>
    super!
    @target\onCollide @

    if @depth < @max_depth
      target = @target\getHitBox!
      bullet = @getHitBox!
      bullet.radius += @attack_range
      if target\contains bullet
        speeds = {{0, 1}, {1, 0}, {-1, 0}, {0, -1}, {1, 1}, {-1, -1}, {-1, 1}, {1, -1}}
        for k, speed in pairs speeds
          copy = @sprite\getCopy!
          copy\scaleUniformly 0.75
          b = SplitShot @position.x, @position.y, (Vector speed[1], speed[2]), @dist * 0.75, copy
          b.depth = @depth + 1
          b.speed_multiplier = @speed_multiplier * 1.5
          b.damage = @damage / 2
          Driver\addObject b, EntityTypes.bullet
