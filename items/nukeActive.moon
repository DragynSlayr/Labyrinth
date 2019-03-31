export class NukeActive extends ActiveItem
  @lowest_rarity = 5
  new: (rarity) =>
    @rarity = rarity
    sprite = Sprite "item/nukeActive.tga", 32, 32, 1, 1.75
    sprite\setRotationSpeed math.pi / 3
    effect = (player) => return
    super sprite, 25, effect
    @name = "Tactical Nuke"
    @description = "25 Killstreak Required"
    @effect_time = 9.9
    @charged = false
    @onEnd = () =>
      Objectives.mode.complete = true
      ScoreTracker\addScore 5000
      Objectives.mode\finish!
      Objectives.difficulty = (Objectives\getLevel! + 1) * 3

  getStats: =>
    stats = super!
    stats[#stats] = nil
    return stats

  onKill: (entity) =>
    if entity.id == EntityTypes.enemy and entity.__class != CaptureEnemy
      @timer += 1

  update2: (dt) =>
    if not @charged and @timer >= @charge_time
      @timer = 0
      @charged = true
    amount = 0
    if not @charged
      amount = 1 - (@timer / @charge_time)
    @sprite.shader\send "amount", amount
    @sprite\update dt
    if @used
      @effect_timer += dt
      if @effect_timer >= @effect_time
        @effect_timer = 0
        @used = false
        @onEnd!

  draw2: =>
    super!
    if @used
      love.graphics.push "all"
      phase = 255 * (math.sin (10 * @effect_timer))
      setColor 200, phase, phase, 255
      font = Renderer\newFont 20
      love.graphics.setFont font
      message = string.format "Nuke incoming! 0:0%.2f", @effect_time - @effect_timer
      width = (font\getWidth message) / 2
      x = Screen_Size.half_width - width
      y = 75 * Scale.height--Screen_Size.half_height - (font\getHeight! / 2)
      r = 0--(math.sin (12.5 * @effect_timer)) / 2
      xs = ((math.sin (6.25 * @effect_timer)) / 2) + 1.5
      love.graphics.printf message, x + width, y, width * 2, "left", r, xs, 1, width, 0
      love.graphics.pop!
