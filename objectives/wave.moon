export class Wave
  new: (parent) =>
    @elapsed = 0
    @delay = 5
    @waiting = true
    @complete = false
    @parent = parent

  start: =>
    return

  finish: =>
    Driver\killEnemies!

  entityKilled: (entity) =>
    return

  update: (dt) =>
    if @waiting
      @elapsed += dt
      if @elapsed >= @delay
        @elapsed = 0
        @waiting = false
        @start!

  draw: =>
    if @waiting
      love.graphics.push "all"
      message = (@delay - math.floor @elapsed)
      Renderer\drawStatusMessage message, Screen_Size.half_height, (Renderer\newFont 250), Color 255, 255, 255, 255

      message = "Next wave in: " .. message
      font = Renderer\newFont 30
      width = font\getWidth message
      height = font\getHeight!
      x = Screen_Size.width - width - (10 * Scale.width)
      y = (50 * Scale.height) - (height / 2)
      love.graphics.setFont font
      setColor 0, 0, 0, 255
      love.graphics.printf message, x, y, width * 1.5, "left"

      love.graphics.pop!
