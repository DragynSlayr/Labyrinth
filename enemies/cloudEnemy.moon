export class CloudEnemy extends GameObject
  new: (x, y) =>
    sprite = Sprite "enemy/cloud.tga", 32, 32, 1, 1.25
    super x, y, sprite
    @id = EntityTypes.enemy
    @value = 1
    @item_drop_chance = 0.10
    @solid = false

    @health = math.min 1000, 36 + (84.5 * Objectives\getScaling!)
    @max_health = @health
    @max_speed = math.min 500 * Scale.diag, (175 + (54 * Objectives\getScaling!)) * Scale.diag
    @speed_multiplier = @max_speed

    if #Driver.objects[EntityTypes.player] > 0
      @target = Driver.objects[EntityTypes.player][1]
    else
      @health = 0
      return

    @end_delay = 1.5
    @wait_time = 4
    @ai_phase = 1
    @children = {}

    sprite = Sprite "particle/blip.tga", 16, 16, 1, 1
    sprite\setColor {127, 127, 127, 200}
    @trail = ParticleEmitter 0, 0, 1 / 15, 0.5
    @trail.sprite = sprite
    @trail.particle_type = ParticleTypes.poison
    @trail\setSizeRange {0.75, 0.95}
    @trail\setSpeedRange {200, 200}
    @trail\setLifeTimeRange {0.3, 0.7}
    @trail.solid = false

    Driver\addObject @trail, EntityTypes.particle

  kill: =>
    super!
    @trail.health = 0
    for k, v in pairs @children
      v.health = 0
      v.update = (dt) => super dt

  update: (dt) =>
    switch @ai_phase
      when 1
        dist_x = @target.position.x - @position.x
        dist_y = @target.position.y - @position.y
        @speed = Vector dist_x, dist_y
        @speed\toUnitVector!
        @speed = @speed\multiply @speed_multiplier--clamp @speed_multiplier, 0, @max_speed

        @trail.position = @position

        if @elapsed >= @wait_time and (Vector dist_x, dist_y)\getLength! <= (300 * Scale.diag)
          @ai_phase += 1
          @speed = Vector 0, 0
          @elapsed = 0
      when 2
        if @elapsed >= @end_delay
          @elapsed = 0
          te = CloudEnemy @position.x, @position.y
          te.trail.position = te.position
          te.draw_health = false
          te.item_drop_chance = 0
          te.update = (dt) =>
            @health = @max_health
            super dt
          Driver\addObject te, EntityTypes.enemy
          table.insert @children, te
          @ai_phase = 1
    --@sprite.rotation = @target.position\getAngleBetween @position
    super dt

  draw: =>
    super!
