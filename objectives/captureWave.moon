export class CaptureWave extends Wave
  new: (parent) =>
    super parent
    @target = 3
    @captured = 0
    @dead = 0
    @spawn_time = 3 -- ((0.5 / 3) * @parent.wave_count)
    @spawn_num = 3
    @goal_complete = false

    sprite = Sprite "particle/poison.tga", 64, 64, 1, 0.25
    @trail = ParticleEmitter 0, 0, 1 / 4
    @trail.sprite = sprite
    @trail.particle_type = ParticleTypes.poison
    @trail\setSizeRange {1, 1}
    @trail\setSpeedRange {100, 175}
    @trail\setLifeTimeRange {0.25, 0.75}
    @trail.solid = false

    Driver\addObject @trail, EntityTypes.particle

    @timer = 0
    @movement_delay = math.random 3, 8

  start: =>
    tess = TesseractGoal Screen_Size.half_width, Screen_Size.height * 0.75
    num = math.random 1, #Driver.objects[EntityTypes.goal]
    for k, g in pairs Driver.objects[EntityTypes.goal]
      if k == num
        @trail.position = g.position
      g.unlocked = true
      g.tesseract = tess
      g.capture_amount /= 2

    for i = 1, @spawn_num
      Objectives\spawn (CaptureEnemy), EntityTypes.enemy
    Driver\addObject tess, EntityTypes.goal

  finish: =>
    super!
    Driver\removeObject @trail, false

  entityKilled: (entity) =>
    if entity.id == EntityTypes.goal and entity.goal_type == GoalTypes.tesseract
      @goal_complete = true
      for k, g in pairs Driver.objects[EntityTypes.goal]
        g.tesseract = nil

  update: (dt) =>
    super dt
    if not @waiting
      @parent.time_remaining -= dt
      @elapsed += dt
      @timer += dt
      if @elapsed >= @spawn_time
        @elapsed = 0
        for i = 1, @spawn_num
          Objectives\spawn (CaptureEnemy), EntityTypes.enemy
      if @timer >= @movement_delay
        @timer = 0
        num = math.random 1, #Driver.objects[EntityTypes.goal] - 1
        @trail.position = Driver.objects[EntityTypes.goal][num].position
        @movement_delay = math.random 3, 8
    if @parent.time_remaining <= 0
      Driver.game_over!
    if @goal_complete
      @complete = true
      Driver\killEnemies!
      for k, o in pairs Driver.objects[EntityTypes.goal]
        o.unlocked = false

  draw: =>
    message = "seconds"
    num = math.floor @parent.time_remaining
    if num == 1
      message = "second"
    @parent.message1 = num .. " " .. message .. " remaining!"
    super!
