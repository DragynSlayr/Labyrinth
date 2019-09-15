export class CloudEnemy extends GameObject
  new: (x, y) =>
    sprite = Sprite "enemy/cloud.tga", 32, 32, 1, 1.25
    super x, y, sprite
    @solid = false

    @health = 100
    @max_health = @health
    @max_speed = 175 * Scale.diag
    @speed_multiplier = @max_speed

    @target = MainPlayer

    @end_delay = 1.5
    @wait_time = 4
    @ai_phase = 1
    @children = {}

    sprite = Sprite "particle/blip.tga", 16, 16, 1, 1
    sprite\setColor {255, 255, 0, 200}
    @trail = ParticleEmitter 0, 0, 1 / 15, 0.5
    @trail.sprite = sprite
    @trail.particle_type = ParticleTypes.poison
    @trail\setSizeRange {0.75, 0.95}
    @trail\setSpeedRange {200, 200}
    @trail\setLifeTimeRange {0.3, 0.7}
    @trail.damage = 0.5

    EnemyHandler\add @

  kill: =>
    super!
    @trail.health = 0
    for k, v in pairs @children
      v.health = 0

  update: (dt) =>
    if @ai_phase == 1
      dist_x = @target.position.x - @position.x
      dist_y = @target.position.y - @position.y
      @speed = Vector dist_x, dist_y
      @speed\toUnitVector!
      @speed = @speed\multiply @speed_multiplier
      @trail.position = Vector @position.x - Screen_Size.half_width, @position.y - Screen_Size.half_height
      if @elapsed >= @wait_time and (Vector dist_x, dist_y)\getLength! <= (300 * Scale.diag)
        @ai_phase = 2
        @speed = Vector 0, 0
        @elapsed = 0
    else if @ai_phase == 2
      if @elapsed >= @end_delay
        @elapsed = 0
        te = CloudEnemy @position.x - Screen_Size.half_width, @position.y - Screen_Size.half_height
        te.trail.position = Vector te.position.x - Screen_Size.half_width, te.position.y - Screen_Size.half_height
        te.draw_health = false
        te.update = (dt) =>
          @health = @max_health
          super dt
        table.insert @children, te
        @ai_phase = 1
    super dt
