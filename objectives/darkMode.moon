export class DarkMode extends Mode
  new: (parent) =>
    super parent
    @objective_text = "Find the locked hearts"
    @mode_type = ModeTypes.dark

  nextWave: =>
    super!
    @wave = DarkWave @

  finish: =>
    for k, p in pairs Driver.objects[EntityTypes.player]
      p.hit = p.health < p.max_health * 0.75
    super!
