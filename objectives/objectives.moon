export class ObjectivesHandler
  new: =>
    @mode = nil
    @elapsed = 0
    @delay = 3
    @modes = {
      AttackMode @,
      EliminationMode @,
      DefendMode @,
      --DarkMode @,
      CaptureMode @
      --TestMode @
    }
    @boss_mode = BossMode @
    @num_modes = #@modes
    shuffle @modes
    @counter = 0
    @difficulty = 0
    @basicChance = 0.8
    @playerChance = 0.1
    @strongChance = 0.05
    @spawnerChance = 0.05
    @shader = nil
    @ready = false
    @bosses_beaten = 0

    s = ""
    i = 1
    while i <= #@modes
      s ..= @modes[i].__class.__name
      if (i + 1 <= #@modes)
        s ..= ", "
      i += 1
    print s

  nextMode: =>
    @counter += 1
    if @counter <= @num_modes
      @mode = @modes[@counter]
    else
      @counter = 0
      shuffle @modes
      --@nextMode!
      -- Boss Wave
      @mode = @boss_mode
    --@mode = @boss_mode
    @mode\start!

    --@mode.complete = true
    --@ready = true

  entityKilled: (entity) =>
    @mode\entityKilled entity

  update: (dt) =>
    start_difficulty = @difficulty
    if not @mode.complete
      @mode\update dt
      if @mode.complete
        ScoreTracker\addScore 5000
        @mode\finish!
    else
      @elapsed += dt
      if @elapsed >= @delay and @ready
        @ready = false
        @elapsed = 0
        Driver\clearAll!
        Driver.game_state = Game_State.upgrading
        --UI\set_screen Screen_State.upgrade
    if start_difficulty ~= @difficulty
      factor = (@difficulty - 1) * 0.02
      @basicChance = clamp 0.80 - factor, 0.20, 0.80
      @playerChance = clamp 0.05 + (factor / 4), 0.05, 0.20
      @strongChance = clamp 0.05 + (factor / 4), 0.05, 0.20
      @spawnerChance = clamp 0.05 + (factor / 4), 0.05, 0.20
    Driver.shader = @shader

  draw: =>
    if not @mode.complete
      @mode\draw!
    else
      love.graphics.push "all"
      font = Renderer\newFont 70
      Renderer\drawStatusMessage "Objective Complete!", Screen_Size.half_height, font, Color 255, 255, 255, 255
      love.graphics.pop!

  getLevel: =>
    level = math.ceil @difficulty / 3
    level -= 1
    return level

  getScaling: =>
    return @bosses_beaten

  getRandomEnemy: (basicChance = @basicChance, playerChance = @playerChance, strongChance = @strongChance, spawnerChance = @spawnerChance) =>
    num = math.random!
    if num <= basicChance
      return (BasicEnemy), 1
    elseif num <= basicChance + playerChance
      return (PlayerEnemy), 1
    elseif num <= basicChance + playerChance + strongChance
      return (StrongEnemy), 1
    else
      return (SpawnerEnemy), 5
