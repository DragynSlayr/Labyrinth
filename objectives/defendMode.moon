export class DefendMode extends Mode
  new: (parent) =>
    super parent
    @objective_text = "Protect the objective"
    @mode_type = ModeTypes.defend

  nextWave: =>
    super!
    @wave = DefendWave @
