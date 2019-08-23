export class Quest
  new: (qtype, goal, amount = 0) =>
    @type = qtype
    @goal = goal.__name
    @amount = amount

    @count = 0
    @done = false

    @callback = () =>
      return

    QuestHandler\add @

  onKill: (entity) =>
    if @type != QuestTypes.kill
      return
    name = entity.__class.__name
    if name == @goal
      @count += 1
      if @count >= @amount
        @done = true
        @callback!

  update: (dt) =>
    if @type == QuestTypes.kill
      return

  kill: =>
    MainPlayer.popup = PopupText Screen_Size.half_width, Screen_Size.half_height, "Quest Complete", 4, Renderer\newFont 30
    MainPlayer.popup.color = {150, 255, 255, 255}

  __tostring: =>
    s = ""
    switch @type
      when QuestTypes.kill
        s ..= @type .. " " .. @count .. "/" .. @amount .. " " .. @goal
        if @amount != 1
          s ..= "s"
      else
        s = ""
    return s

export class QuestDriver extends Handler
  new: =>
    super!
    @padding = 10
    @linePadding = 5

  onKill: (entity) =>
    for k, v in pairs @objects
      v\onKill entity

  drawQuests: =>
    font = love.graphics.getFont!
    love.graphics.setFont (Renderer\newFont 30)

    width = 0
    for k, v in pairs @objects
      w = love.graphics.getFont!\getWidth v\__tostring!
      if w > width
        width = w

    width += 2 * @padding
    height = (2 * @padding) + ((#@objects - 1) * @linePadding) + (#@objects * love.graphics.getFont!\getHeight!)
    x = Screen_Size.width - width - @padding
    y = @padding + 25

    setColor 0, 0, 0, 200
    love.graphics.rectangle "fill", x, y, width, height, 10, 10
    love.graphics.setLineWidth 3
    setColor 150, 150, 150, 255
    love.graphics.rectangle "line", x, y, width, height, 10, 10
    love.graphics.setLineWidth 1


    for k, v in pairs @objects
      love.graphics.printf (tostring v), x + @padding, y + @padding + ((k - 1) * (@linePadding + love.graphics.getFont!\getHeight!)), width, "left"

    love.graphics.setFont font

  drawEmpty: =>
    font = love.graphics.getFont!
    love.graphics.setFont (Renderer\newFont 30)

    message = "No Quests Available"
    width =(2 * @padding) + love.graphics.getFont!\getWidth message
    height = (2 * @padding) + love.graphics.getFont!\getHeight!
    x = Screen_Size.width - width - @padding
    y = @padding + 25

    setColor 0, 0, 0, 200
    love.graphics.rectangle "fill", x, y, width, height, 10, 10
    love.graphics.setLineWidth 3
    setColor 150, 150, 150, 255
    love.graphics.rectangle "line", x, y, width, height, 10, 10
    love.graphics.setLineWidth 1

    love.graphics.printf message, x + @padding, y + @padding, width, "left"

    love.graphics.setFont font

  draw: =>
    Camera\unset!

    if #@objects > 0
      @drawQuests!
    else
      @drawEmpty!

    Camera\set!
