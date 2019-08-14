export class Mode
  new: (parent) =>
    @parent = parent
    @level_count = 1
    @wave_count = 1
    @complete = false
    @wave = nil
    @message1 = ""
    @message2 = ""
    @objective_text = ""
    @started = false
    @mode_type = ""

  entityKilled: (entity) =>
    @wave\entityKilled entity

  nextWave: =>
    @parent.difficulty += 1

  start: =>
    @complete = false
    @wave_count = 1
    @nextWave!
    @started = true

  finish: =>
    Driver\clearAll {EntityTypes.player, EntityTypes.item}
    for k, p in pairs Driver.objects[EntityTypes.player]
      p.can_place = true
      p.health = p.max_health
      p.attack_range = Stats.player[2]
    if #Driver.objects[EntityTypes.player] > 1
      for i = 2, #Driver.objects[EntityTypes.player]
        Driver.objects[EntityTypes.player][i].health = 0
    @parent.shader = nil

  update: (dt) =>
    if not @complete
      if not @started
        @start!
      if not @wave.complete
        @wave\update dt
        level = Objectives\getLevel! + 1
        @message2 = "Level " .. level .. "\tWave " .. @wave_count .. "/3"
        if @wave.complete
          @wave\finish!
      else
        @wave_count += 1
        if (@wave_count - 1) % 3 == 0
          @level_count += 1
          @complete = true
          @started = false
        else
          @nextWave!

  draw: =>
    @wave\draw!
    love.graphics.push "all"
    setColor 0, 0, 0, 255
    font = Renderer\newFont 30
    love.graphics.setFont font
    love.graphics.printf @message1, 10 * Scale.width, 20 * Scale.height, Screen_Size.width, "left"
    Renderer\drawAlignedMessage @message2, 20 * Scale.height, "center", font
    Renderer\drawAlignedMessage @objective_text, 50 * Scale.height, "center", font
    love.graphics.pop!
