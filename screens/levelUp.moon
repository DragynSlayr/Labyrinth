export class LevelUp extends Screen
  new: (@player) =>
    @isOpen = false
    @elapsed = 0
    @delay = 0.5

    @x = 8
    @y = 80
    @width = Screen_Size.half_width * 0.5
    @height = Screen_Size.half_height * 1.3

    @pointsAvailable = 10
    @stats = {}
    @loadPlayerStats!

    @buttons = {}
    @makeButtons!

    @popup = nil

  loadPlayerStats: () =>
    for k, v in pairs @player.stats
      @stats[k] = v

  updatePlayerStats: () =>
    for k, v in pairs @stats
      @player.stats[k] = v
    @player\updateStats!

  makeButtons: () =>
    y_start = @y + (@height * 0.17)
    i = 1
    nil_color = Color 0, 0, 0, 0
    for k, v in pairs @stats
      y = y_start + (i * 45) + 10

      db = Button @x + (@width * 0.82), y, 20, 20, '-', () ->
        if  @stats[k] > @player.stats[k]
          @pointsAvailable += 1
          @stats[k] -= 1
      db.font_color = Color 255, 125, 95
      db.sprited = false
      db.idle_color = nil_color
      db.hover_color = nil_color

      ub = Button @x + (@width * 0.9), y, 20, 20, '+', () ->
        if @pointsAvailable > 0
          @pointsAvailable -= 1
          @stats[k] += 1
      ub.font_color = Color 95, 255, 125
      ub.sprited = false
      ub.idle_color = nil_color
      ub.hover_color = nil_color

      table.insert @buttons, db
      table.insert @buttons, ub

      i += 1

    popup_color = {(Color 200, 150, 200)\get!}
    y = y_start + (i * 45) + 10
    apply = Button @x + (@width * 0.8), y, @width * 0.2, 30, 'Apply', (() ->
      changes = 0
      for k, v in pairs @stats
        changes += v - @player.stats[k]
      if changes > 0
        @updatePlayerStats!
        @loadPlayerStats!
        @popup = PopupText @x + (@width / 2), y + 55, "Stats Applied", 3, Renderer\newFont 30
        if @pointsAvailable == 0
          Timer 3, @, (() =>
            @parent.isOpen = false
          ), false
      else
        @popup = PopupText @x + (@width / 2), y + 55, "No Stats Changed", 3, Renderer\newFont 30
      @popup.color = popup_color
    ), Renderer\newFont 20
    apply.sprited = false
    table.insert @buttons, apply

  mousepressed: (x, y, button, isTouch) =>
    for k, v in pairs @buttons
      v\mousepressed x, y, button, isTouch

  mousereleased: (x, y, button, isTouch) =>
    for k, v in pairs @buttons
      v\mousereleased x, y, button, isTouch

  update: (dt) =>
    @elapsed += dt
    if @elapsed > @delay
      if love.keyboard.isDown Controls.keys.OPEN_LEVEL_UP
        @elapsed = 0
        @isOpen = not @isOpen
    if not @isOpen return
    for k, v in pairs @buttons
      v\update dt
    if @popup
      @popup\update dt

  mouseOn: (x, y) =>
    if not @isOpen
      return false
    else
      xOn = x >= @x and x <= @x + @width
      yOn = y >= @y and y <= @y + @height
      return xOn and yOn

  draw: =>
    if not @isOpen return

    Camera\unset!

    setColor 50, 50, 50, 200
    love.graphics.rectangle "fill", @x, @y, @width, @height

    setColor 255, 255, 255, 255
    love.graphics.printf "Character", @x, @y + (@height * 0.02), @width, "center"

    @player.sprite\draw @x + (@width / 2), @y + (@height * 0.12)

    y_start = @y + (@height * 0.17)
    i = 1
    for k, v in pairs @stats
      y = y_start + (i * 45)
      if v == @player.stats[k]
        setColor 95, 125, 255, 255
      else
        setColor 50, 255, 50, 255
      love.graphics.printf k, @x + (@width * 0.05), y, @width
      love.graphics.printf v, @x + (@width * 0.7), y, @width

      i += 1

    y = y_start + (i * 45)
    setColor 95, 125, 255, 255
    love.graphics.printf ('Points Available: ' .. @pointsAvailable), @x + (@width * 0.05), y, @width

    for k, v in pairs @buttons
      v\draw!

    if @popup
      @popup\draw!
      if not @popup.active
        @popup = nil

    Camera\set!
