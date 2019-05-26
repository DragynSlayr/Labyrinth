export class ItemPedestal extends BackgroundObject
  new: (x, y, item) =>
    sprite = Sprite "item/pedestal.tga", 32, 32, 1, 3
    super x, y, sprite
    @item = item
    @item.position = Vector @position.x, @position.y - (@sprite.scaled_width * 0.3)
    @collectable = true

  update: (dt) =>
    if not @collectable return
    super dt
    for k, p in pairs Driver.objects[EntityTypes.player]
      player = p\getHitBox!
      box = @getHitBox!
      if player\contains box
        @pickup p

  pickup: (player) =>
    @item\pickup player
    @health_drain_rate = 0.1

  draw: =>
    super!

    @item\draw!
