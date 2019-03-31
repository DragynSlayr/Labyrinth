export class TestMode extends Mode
  new: (parent) =>
    super parent
    @objective_text = "Testing Mode"
    @mode_type = ModeTypes.test

  nextWave: =>
    super!
    @wave = TestWave @
