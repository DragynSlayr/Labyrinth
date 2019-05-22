export class HomingProjectile extends GameObject
  new: (x, y, target, sprite) =>
    super x, y, sprite
    @target = target
    @attack_range = 15 * Scale.diag
    @damage = 1 / 10
    @id = EntityTypes.bullet
    @draw_health = false
    @solid = false
    @speed_multiplier = 500
    @block_rotation = true

    sprite_copy = sprite\getCopy!
    --sprite_copy\setColor {50, 50, 50, 255}
    @trail = nil--ParticleTrail x, y, sprite_copy, @

    @death_sound = 0

  update: (dt) =>
    if not @alive
      return
    if not @target
      @kill!

    if @trail
      @trail\update dt
    @sprite\update dt

    @speed = Vector @target.position.x - @position.x, @target.position.y - @position.y
    @speed\toUnitVector!
    @speed = @speed\multiply @speed_multiplier

    @position\add @speed\multiply dt

    if @block_rotation
      vec = Vector 0, 0
      @sprite.rotation = @speed\getAngleBetween vec

    target = @target\getHitBox!
    bullet = @getHitBox!
    bullet.radius += @attack_range
    if target\contains bullet
      @target\onCollide @
      MusicPlayer\play @death_sound
      @kill!

  draw: =>
    if @speed\getLength! > 0
      if @target and @target.alive and @alive
        if DEBUGGING
          setColor 255, 0, 255, 127
          enemy = @getHitBox!
          love.graphics.circle "fill", @position.x, @position.y, @attack_range + enemy.radius, 360
        super!
