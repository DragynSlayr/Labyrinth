export class FilteredBullet extends GameObject
  new: (x, y, damage, speed, filter = {}) =>
    sprite = Sprite "enemy/bullet.tga", 26, 20, 1, 0.5
    super x - Screen_Size.half_width, y - Screen_Size.half_height, sprite
    @filter = filter
    @damage = damage
    @attack_range = 15 * Scale.diag
    @speed = speed
    @id = EntityTypes.bullet
    @draw_health = false
    @solid = false
    @target_hit = false

    @max_dist = 2 * (math.max Screen_Size.width, Screen_Size.height)
    @dist_travelled = 0

    @trail = nil

    sound = Sound "player_bullet.ogg", 0.025, false, 1.125, true
    @death_sound = MusicPlayer\add sound

    @fix_rotation = true

  update: (dt) =>
    if not @alive
      return

    if not (@isOnScreen Screen_Size.border)
      @health = 0
      return

    if @trail
      @trail\update dt
    @sprite\update dt
    if @fix_rotation
      @sprite.rotation = @speed\getAngle! + (math.pi / 2)

    delta = @speed\multiply dt
    @position\add delta
    @dist_travelled += delta\getLength!

    if @dist_travelled >= @max_dist
      sprite = Sprite "particle/blip.tga", 16, 16, 1, 0.5
      sprite\setColor {50, 100, 100, 0}
      particle = Particle @position.x - Screen_Size.half_width, @position.y - Screen_Size.half_height, sprite, 127, 15, 0.5
      Driver\addObject particle, EntityTypes.particle
      @health = 0
      return

    if #@filter == 0
      @health = 0
      return

    for k, filter in pairs @filter
      for k2, o in pairs Driver.objects[filter]
        target = o\getHitBox!
        bullet = @getHitBox!
        bullet.radius += @attack_range
        if target\contains bullet
          o\onCollide @
          MusicPlayer\play @death_sound
          @health = 0
          @target_hit = true

  kill: =>
    super!
    if @target_hit and Driver.objects[EntityTypes.player]
      for k, p in pairs Driver.objects[EntityTypes.player]
        if p\hasItem (LifeStealPassive)
          p.health += MainPlayer.damage * 0.01
          p.health = math.min p.health, p.max_health
    if @trail
      @trail.health = 0

  draw: =>
    if @speed\getLength! > 0
      if @alive
        if DEBUGGING
          setColor 255, 0, 255, 127
          love.graphics.circle "fill", @position.x, @position.y, @attack_range + @getHitBox!.radius, 360
        super!
