export class BlackHole extends BackgroundObject
  new: (x, y) =>
    sprite = Sprite "background/blackhole.tga", 32, 32, 1, 1.25
    super x, y, sprite
    @life_time = 7.5
    @diag = (Vector Screen_Size.border[3], Screen_Size.border[4])\getLength!
    @sprite\setRotationSpeed -math.pi / 2

  kill: =>
    super!
    for k, e in pairs EnemyHandler.objects
      e.speed_override = false
    for k, b in pairs BossHandler.objects
      b.speed_override = false

  update: (dt) =>
    ratio = (7.5 - @life_time) / 7.5
    @sprite\setRotationSpeed (ratio * -2 * math.pi)
    super dt
    for k, e in pairs EnemyHandler.objects
      @applyPull e, dt
      @applyDamage e
    for k, b in pairs BossHandler.objects
      @applyPull b, dt
      @applyDamage b
    @life_time -= dt
    if @life_time <= 0
      @health = 0

  applyPull: (entity, dt) =>
    x = @position.x - entity.position.x
    y = @position.y - entity.position.y
    vec = Vector x, y
    ratio = vec\getLength! / @diag
    ratio = map ratio, 0, 1, 1, 0
    entity\setSpeedOverride vec, ratio

  applyDamage: (entity) =>
    x = @position.x - entity.position.x
    y = @position.y - entity.position.y
    vec = Vector x, y
    ratio = vec\getLength! / @diag
    ratio *= 300
    @damage = 1 / ratio
    entity\onCollide @
