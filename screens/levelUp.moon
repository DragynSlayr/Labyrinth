export class LevelUp extends Screen
  new: (@player) =>
    @isOpen = false
    @elapsed = 0
    @delay = 0.5

  update: (dt) =>
    @elapsed += dt
    if @elapsed > @delay
      if love.keyboard.isDown Controls.keys.OPEN_LEVEL_UP
        @elapsed = 0
        @isOpen = not @isOpen

  draw: =>
    if not @isOpen return

    Camera\unset!

    x = 75
    y = 50
    width = Screen_Size.half_width * 0.5
    height = Screen_Size.half_height * 1.3
    setColor 50, 50, 50, 200
    love.graphics.rectangle "fill", x, y, width, height

    setColor 255, 255, 255, 255
    love.graphics.printf "Character", x, y + (height * 0.02), width, "center"

    y += height * 0.12
    @player.sprite\draw x + (width / 2), y

    y_start = y + (height * 0.05)
    i = 1
    for k, v in pairs @player.stats
      y = y_start + (i * 45)
      setColor 95, 125, 255, 255
      love.graphics.printf k, x + (width * 0.05), y, width
      love.graphics.printf v, x + (width * 0.7), y, width

      setColor 255, 125, 95, 255
      love.graphics.printf '-', x + (width * 0.82), y, width

      setColor 95, 255, 125, 255
      love.graphics.printf '+', x + (width * 0.9), y, width

      i += 1

    Camera\set!
