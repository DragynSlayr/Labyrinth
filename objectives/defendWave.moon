export class DefendWave extends Wave
  new: (parent) =>
    super parent
    @target = 20
    @dead = 0
    @max_time = 2

  spawnRandomEnemy: =>
    spawnerChance = Objectives.spawnerChance / 3
    basicChance   = Objectives.basicChance + spawnerChance
    playerChance  = Objectives.playerChance + spawnerChance
    strongChance  = Objectives.strongChance + spawnerChance
    Objectives\spawn (Objectives\getRandomEnemy basicChance, playerChance, strongChance, 0), EntityTypes.enemy

  start: =>
    Objectives\spawn (DefendGoal), EntityTypes.goal

  entityKilled: (entity) =>
    if entity.id == EntityTypes.goal
      @dead += 1

  update: (dt) =>
    super dt
    if not @waiting
      @elapsed += dt
      @target -= dt
      if @elapsed >= @max_time and @target > 0
        @elapsed = 0
        @spawnRandomEnemy!
    if @dead > 0
      Driver.game_over!
    if @target <= 0
      @complete = true
      Driver\killEnemies!

  draw: =>
    message = "seconds"
    num = math.floor @target
    if num == 1
      message = "second"
    @parent.message1 = num .. " " .. message .. " remaining!"
    super!
