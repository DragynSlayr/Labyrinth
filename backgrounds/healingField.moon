export class HealingField extends BackgroundObject
  new: (x, y) =>
    sprite = Sprite "background/healingField.tga", 32, 32, 2, 4
    super x, y, sprite
    @life_time = 6.5
    @timer = 0
    @heal_delay = 0.5
    @healing_amount = 1 / 6

  update: (dt) =>
    super dt
    @timer += dt
    if @timer >= @heal_delay
      @timer = 0
      target = MainPlayer\getHitBox!
      healer = @getHitBox!
      if target\contains healer
        MainPlayer.health = clamp MainPlayer.health + @healing_amount, 0, MainPlayer.max_health
    @life_time -= dt
    if @life_time <= 0
      @health = 0
