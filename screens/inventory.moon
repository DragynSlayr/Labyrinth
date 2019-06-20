export class Inventory extends Screen
  new: =>
    @isOpen = false
    @elapsed = 0
    @delay = 0.5

  update: (dt) =>
    @elapsed += dt
    if @elapsed > @delay
      if love.keyboard.isDown Controls.keys.OPEN_INVENTORY
        @elapsed = 0
        @isOpen = not @isOpen
    if @isOpen
      print "Open"
    else
      print "Closed"

  draw: =>
    if not @isOpen return

    Camera\unset!

    setColor 50, 50, 50, 127
    love.graphics.rectangle "fill", Screen_Size.half_width + 75, 50, Screen_Size.half_width - 125, Screen_Size.half_height

    Camera\set!
