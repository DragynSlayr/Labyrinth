export class ItemPedestal extends BackgroundObject
  new: (x, y, item, cost = 0) =>
    sprite = Sprite "item/pedestal.tga", 32, 32, 1, 2.4
    super x, y, sprite
    @item = item
    @item.position = Vector @position.x, @position.y - (@sprite.scaled_width * 0.3)
    @collectable = true
    @cost = cost
    @refilling = false
    @refill_timer = 0
    @refill_started = false

  update: (dt) =>
    super dt
    if not @collectable return
    if @refilling and @refill_started
      @refill_timer += dt
      if @refill_timer >= 3
        @item = ItemPool\getItem!
        @item.position = Vector @position.x, @position.y - (@sprite.scaled_width * 0.3)
        @cost = @item.rarity * 10
        @refill_started = false
        @refill_timer = 0
    if not @item return
    player = MainPlayer\getHitBox!
    box = @getHitBox!
    if player\contains box
      if MainPlayer.coins >= @cost
        MainPlayer.coins -= @cost
        @pickup MainPlayer

  pickup: (player) =>
    @item\pickup player
    @item = nil
    if @refilling and not @refill_started
      @refill_timer = 0
      @refill_started = true
      @cost = 0
    else
      @health_drain_rate = 0.1
      @collectable = false

  draw: =>
    super!

    oldFont = love.graphics.getFont!
    love.graphics.setFont (Renderer\newFont 20)

    if @cost > 0
      if MainPlayer.coins >= @cost
        setColor 255, 215, 0, 255
      else
        setColor 255, 0, 0, 255
      love.graphics.printf ("$ " .. @cost), @position.x - Screen_Size.half_width, @position.y + (@sprite.scaled_height * 0.5), Screen_Size.width, "center"
    if @refilling
      if @refill_started
        setColor 0, 255, 0, ((math.sin (@elapsed * 10)) + 1) * 127
        love.graphics.printf "Restocking", @position.x - Screen_Size.half_width, @position.y + (@sprite.scaled_height * 0.5) + love.graphics.getFont!\getHeight!, Screen_Size.width, "center"
      else
        setColor 0, 255, 0, 255
        love.graphics.printf "Endless", @position.x - Screen_Size.half_width, @position.y + (@sprite.scaled_height * 0.5) + love.graphics.getFont!\getHeight!, Screen_Size.width, "center"

    if @item
      @item\draw!

    love.graphics.setFont oldFont
