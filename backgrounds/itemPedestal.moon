export class ItemPedestal extends BackgroundObject
  new: (x, y, item, cost = 0) =>
    sprite = Sprite "item/pedestal.tga", 32, 32, 1, 3
    super x, y, sprite
    @item = item
    @item.position = Vector @position.x, @position.y - (@sprite.scaled_width * 0.3)
    @collectable = true
    @cost = cost

  update: (dt) =>
    super dt
    if not @collectable return
    for k, p in pairs Driver.objects[EntityTypes.player]
      player = p\getHitBox!
      box = @getHitBox!
      if player\contains box
        if p.coins >= @cost
          p.coins -= @cost
          @collectable = false
          @pickup p

  pickup: (player) =>
    @item\pickup player
    @health_drain_rate = 0.1
    @item = nil

  draw: =>
    super!

    if MainPlayer.coins >= @cost
      setColor 255, 215, 0, 255
    else
      setColor 255, 0, 0, 255
    love.graphics.printf ("$ " .. @cost), @position.x - Screen_Size.half_width, @position.y + (@sprite.scaled_height * 0.5), Screen_Size.width, "center"

    if @item
      @item\draw!
