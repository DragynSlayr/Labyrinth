export class Coin extends BackgroundObject
  new: (x, y, value = 1) =>
    sprite = Sprite "background/coin.tga", 32, 32, 1, 1.5
    super x, y, sprite
    @value = value

  update: (dt) =>
    super dt
    player = MainPlayer\getHitBox!
    box = @getHitBox!
    if player\contains box
      MainPlayer.coins += @value
      @health = 0
