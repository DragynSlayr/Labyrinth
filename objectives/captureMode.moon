export class CaptureMode extends Mode
  new: (parent) =>
    super parent
    @objective_text = "Destroy the objective"
    @mode_type = ModeTypes.capture

    x_space = 100
    y_space = 100

    @point_positions = {
      Vector x_space * Scale.width, Screen_Size.height - Screen_Size.border[2] - (y_space * Scale.height),
      Vector Screen_Size.width - (x_space * Scale.width), Screen_Size.height - Screen_Size.border[2] - (y_space * Scale.height),
      Vector Screen_Size.width / 2, Screen_Size.border[2] + (y_space * Scale.height)
    }

  start: =>
    @time_remaining = 90
    for k, p in pairs @point_positions
      goal = CaptureGoal p.x, p.y
      goal.num = k
      goal.tesseract = tess
      Driver\addObject goal, EntityTypes.goal
    super!

  nextWave: =>
    super!
    @wave = CaptureWave @
