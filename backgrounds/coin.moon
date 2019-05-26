export class Coin extends BackgroundObject
  new: (x, y, value = 1) =>
    sprite = Sprite "background/coin.tga", 32, 32, 1, 1.5
    super x, y, sprite
    @value = value

  update: (dt) =>
    super dt
    for k, p in pairs Driver.objects[EntityTypes.player]
      player = p\getHitBox!
      box = @getHitBox!
      if player\contains box
        p.coins += @value
        @health = 0
