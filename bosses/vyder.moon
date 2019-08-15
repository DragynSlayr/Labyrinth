export class BossVyder extends Boss
  new: (x, y) =>
    sprite = Sprite "boss/fox_bat/fox_bat.tga", 729, 960, 1, 1
    sprite\setScale 0.25, 0.25
    super x, y, sprite
    @bossType = BossTypes.vyder
    @score_value = 1000
    @exp_given = @score_value + (@score_value * 0.35 * Objectives\getLevel!)

    level = Objectives\getScaling!
    @health = 2000 + (3000 * level)
    @max_health = @health
    @max_speed = math.min 600, 300 + (100 * level)
    @speed_multiplier = @max_speed
    @damage = 0--(5 / 60) + ((10 / 60) * level)

    @boost_multiplier = 3
    @chase_time = 0
    @attack_range = 100 * Scale.diag

    @trail = ParticleEmitter @position.x, @position.y, 0.5, 12, @
    @trail.sprite = Sprite "particle/poison.tga", 64, 64, 1, 1.75
    @trail.particle_type = ParticleTypes.poison

    @ai_phase = 1
    @ai_time = 0
    @target_position = Driver\getRandomPosition!

    @cooldown_sprite = Sprite "boss/fox_bat/fox_batAction.tga", 729, 960, 1, 1
    @cooldown_sprite\setScale 0.25, 0.25
    @cooldown_time = 6

    @fast_poison_time = 5

  getHitBox: =>
    -- Get the radius of this Sprite as the minimum of height and width
    radius = math.min @sprite.scaled_height / 2, @sprite.scaled_width / 2
    radius *= 0.75

    -- Return a new Circle at this x and y with the radius
    return Circle @position.x, @position.y + (25 * Scale.height), radius

  update: (dt) =>
    @speed_multiplier = clamp @speed_multiplier + 1, 0, @max_speed
    @ai_time += dt
    switch @ai_phase
      when 1
        @speed = Vector @target_position.x - @position.x, @target_position.y - @position.y
        dist = @speed\getLength!
        @speed\toUnitVector!
        @speed = @speed\multiply @speed_multiplier
        super dt
        @chase_time += dt
        if dist <= @getHitBox!.radius or @chase_time >= 3
          @chase_time = 0
          @target_position = Driver\getRandomPosition!
        if @ai_time >= 10
          @ai_time = 0
          @ai_phase += 1
      when 2
        target = MainPlayer
        @target_position = target.position
        @ai_time = 0
        @ai_phase += 1
      when 3
        @speed = Vector @target_position.x - @position.x, @target_position.y - @position.y
        dist = @speed\getLength!
        @speed\toUnitVector!
        @speed = @speed\multiply @speed_multiplier * @boost_multiplier
        super dt
        @chase_time += dt
        if dist < @getHitBox!.radius + (@attack_range / 2) or @ai_time >= 1
          @ai_time = 0
          @ai_phase += 1
      when 4
        @speed = Vector 0, 0
        @old_trail_delay = @trail.delay
        @trail.delay = 0.1
        @ai_time = 0
        @ai_phase += 1
      when 5
        if @ai_time >= @fast_poison_time
          @ai_time = 0
          @ai_phase += 1
          @trail.delay = @old_trail_delay
          @old_trail_delay = nil
          @old_sprite = @sprite
          @sprite = @cooldown_sprite
          @trail\stop!
          @target_position = Driver\getRandomPosition!
      when 6
        super dt
        @speed = Vector @target_position.x - @position.x, @target_position.y - @position.y
        dist = @speed\getLength!
        @speed\toUnitVector!
        @speed = @speed\multiply @speed_multiplier
        super dt
        @chase_time += dt
        if dist <= @getHitBox!.radius or @chase_time >= 3
          @chase_time = 0
          @target_position = Driver\getRandomPosition!
        if @ai_time >= @cooldown_time
          @ai_time = 0
          @ai_phase = 1
          @sprite = @old_sprite
          @old_sprite = nil
          @trail\start!

  draw: =>
    if DEBUGGING
      love.graphics.setShader Driver.shader
      setColor 255, 0, 0, 255
      love.graphics.circle "fill", @target_position.x, @target_position.y, 3, 360
      love.graphics.setShader!
    super!
