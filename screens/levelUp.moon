export class LevelUp extends Screen
  new: =>
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

    setColor 50, 50, 50, 127
    love.graphics.rectangle "fill", 75, 50, Screen_Size.half_width * 0.5, Screen_Size.half_height * 1.3

    Camera\set!
