export class AttackWave extends Wave
  new: (parent) =>
    super parent
    @killed = 0
    @target = @parent.wave_count
    @spawn_count = @target
    @max_time = (3 / @spawn_count) + 1

  spawnRandomEnemy: =>
    spawnerChance = Objectives.spawnerChance / 3
    basicChance   = Objectives.basicChance + spawnerChance
    playerChance  = Objectives.playerChance + spawnerChance
    strongChance  = Objectives.strongChance + spawnerChance
    Objectives\spawn (Objectives\getRandomEnemy basicChance, playerChance, strongChance, 0), EntityTypes.enemy

  start: =>
    --print @target
    for i = 1, @target
      goal = Objectives\spawn (AttackGoal), EntityTypes.goal
      --em = ParticleEmitter 0, 0, 0.1, 0.5, goal
      --Driver\addObject em, EntityTypes.particle

  entityKilled: (entity) =>
    if entity.id == EntityTypes.goal
      @killed += 1
      @spawnRandomEnemy!

  update: (dt) =>
    super dt
    if not @waiting
      @elapsed += dt
      if @elapsed >= @max_time and @killed ~= @target
        @elapsed = 0
        @spawn_count += 1
        @max_time = (3 / @spawn_count) + 1
        @spawnRandomEnemy!
    if @killed >= @target and (Driver\isClear true, false)
      --Driver\killEnemies!
      @complete = true

  draw: =>
    num = @target - @killed
    message = "beacons"
    if num == 1
      message = "beacon"
    @parent.message1 = num .. " " .. message .. " remaining!"
    super!
