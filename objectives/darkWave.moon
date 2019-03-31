export class DarkWave extends Wave
  new: (parent) =>
    super parent
    @killed = 0
    @target = 3--4 - @parent.wave_count
    Objectives.shader = love.graphics.newShader "shaders/distance.fs"
    Objectives.shader\send "screen_size", Screen_Size.size
    Objectives.shader\send "size", 10
    a = math.log Stats.player[1]
    b = math.log Base_Stats.player[1]
    @max_health = 25 * (a / b)
    @health = @max_health

    @heart_timer = 0
    lower = clamp ((-4 / 30) * Objectives\getScaling!) + 5, 1, 5
    @heart_max_time = map math.random!, 0, 1, lower, lower + 1

  start: =>
    for k, p in pairs Driver.objects[EntityTypes.player]
      @health = map p.health, 0, p.max_health, 0, @max_health
      p.attack_range = Base_Stats.player[2]
    @respawnHearts!

  respawnHearts: =>
    Driver\clearObjects EntityTypes.goal
    for i = 1, 3
      @spawnHeart i > 1

  spawnHeart: (isFake = false) =>
    goal = Objectives\spawn (FindGoal), EntityTypes.goal
    if isFake
      temp = FakeFindGoal goal.position.x, goal.position.y
      Driver\removeObject goal, false
      Driver\addObject temp, EntityTypes.goal
      goal = temp
    goal.trail = ParticleEmitter goal.position.x, goal.position.y, 1 / 60
    goal.trail.position = Vector Screen_Size.half_width, Screen_Size.half_height
    goal.trail.shader = love.graphics.newShader "shaders/normal.fs"
    goal.trail.sprite = Sprite "particle/orb.tga", 32, 32, 1, 0.5
    goal.trail.moving_particles = false
    goal.trail\setLifeTimeRange {0.25, 0.75}
    goal.trail\setSizeRange {0.1, 1.0}

  entityKilled: (entity) =>
    if entity.id == EntityTypes.goal
      @killed += 1
      ScoreTracker\addScore 500
      @health += 6
      @health = clamp @health, 0, @max_health
      @heart_timer = @heart_max_time

  update: (dt) =>
    for k, v in pairs Driver.objects[EntityTypes.player]
      Objectives.shader\send "player_pos", {v.position.x, v.position.y}
      break

    super dt
    if not @waiting
      for k, v in pairs Driver.objects[EntityTypes.player]
        @health -= (1 * dt)
        v.health = map @health, 0, @max_health, 0, Stats.player[1]
        v.health = clamp v.health, 0, v.max_health

      if @killed >= @target
        Driver\killEnemies!
        Driver\clearObjects EntityTypes.goal
        @complete = true
        @heart_timer = 0
        return

      @heart_timer += dt
      if @heart_timer >= @heart_max_time
        @heart_timer = 0
        @respawnHearts!

  draw: =>
    num = @target - @killed
    message = "hearts"
    if num == 1
      message = "heart"
    @parent.message1 = num .. " " .. message .. " remaining!"
    super!
