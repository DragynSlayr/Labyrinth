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
    Camera\unset!

    x = 40
    y = 40

    love.graphics.setLineWidth 5
    setColor 0, 0, 0, 255
    love.graphics.rectangle "line", 10, 10, 60, 60
    love.graphics.setLineWidth 1

    if @charged
      setColor 139, 69, 19, 255
    else
      setColor 15, 87, 132, 200
    love.graphics.rectangle "fill", x - (30 * Scale.width), y - (30 * Scale.height), 60 * Scale.width, 60 * Scale.height

    @sprite\draw x, y

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

    Camera\set!

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
