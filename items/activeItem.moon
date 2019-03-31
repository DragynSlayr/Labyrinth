export class ActiveItem extends Item
  new: (sprite, charge_time = 0, effect) =>
    super sprite
    @item_type = ItemTypes.active
    @charged = true
    @charge_time = charge_time
    @effect = effect

    @sprite\setShader love.graphics.newShader "shaders/active_item_shader.fs"

    @used = false
    @effect_time = 0
    @effect_timer = 0

    @onEnd = () -> return

  getStats: =>
    stats = super!
    table.insert stats, "Cooldown: " .. @charge_time .. "s"
    return stats

  use: =>
    if @charged
      @timer = 0
      @charged = false
      @effect @player
      @used = true

  draw2: =>
    love.graphics.push "all"

    x = ((Screen_Size.width / 2) + (10 * Scale.width)) / 2
    y = Screen_Size.height - (35 * Scale.height)

    if @charged
      setColor 132, 87, 15, 200
    else
      setColor 15, 87, 132, 200
    love.graphics.rectangle "fill", x - (60 * Scale.width * 0.5), y - (60 * Scale.height * 0.5), 60 * Scale.width, 60 * Scale.height

    @sprite\draw x, y

    if not @charged
      setColor 0, 0, 0, 127
      font = Renderer\newFont 30
      love.graphics.setFont font
      message = math.ceil (@charge_time - @timer)
      love.graphics.printf message, x + (60 * Scale.width * 0.5), y - (font\getHeight! / 2), 60 * Scale.width, "center"

    if @used and @effect_time and @effect_timer
      love.graphics.setShader Driver.shader

      radius = @player\getHitBox!.radius
      x = @player.position.x - radius
      y = @player.position.y + radius + (5 * Scale.height)

      setColor 0, 0, 0, 255
      love.graphics.rectangle "fill", x, y, radius * 2, 10 * Scale.height

      ratio = (@effect_time - @effect_timer) / @effect_time

      setColor 0, 255, 255, 200
      love.graphics.rectangle "fill", x + (1 * Scale.width), y + (1 * Scale.height), ((radius * 2) - (2 * Scale.width)) * ratio, 8 * Scale.height

      love.graphics.setShader!

    love.graphics.pop!

  update2: (dt) =>
    super dt
    if @charged
      @sprite\update dt
    if not @charged and @timer >= @charge_time
      @timer = 0
      @charged = true
    amount = 0
    if not @charged
      amount = 1 - (@timer / @charge_time)
    @sprite.shader\send "amount", amount
    if @used
      @sprite.current_frame = clamp (math.floor @sprite.frames / 2) + 1, 1, @sprite.frames
      @effect_timer += dt
      if @effect_timer >= @effect_time
        @effect_timer = 0
        @used = false
        @onEnd!
