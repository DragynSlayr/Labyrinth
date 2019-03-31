export class Jitter extends BackgroundObject
  new: (x, y) =>
    sprite = Sprite "maps/block.tga", 32, 32, 1, 0.5
    super x, y, sprite
    @sprite\setColor {0, 0, 0, 0}
    @change_time = 0.25
    @change_timer = 0
    @speed = Vector 0, 0
    @speed_multiplier = 200

  onCollide: (object) =>
    @health = 0

  update: (dt) =>
    @change_timer += dt
    if @change_timer >= @change_time
      @change_timer = 0
      @speed = getRandomUnitStart @speed_multiplier
    super dt
