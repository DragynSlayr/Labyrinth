export class LinearProjectile extends HomingProjectile
  new: (x, y, speed, dist = Screen_Size.width, sprite) =>
    target_pos = Vector speed\getComponents!
    target_pos = target_pos\multiply dist
    target_pos\add (Vector x, y)
    super x, y, (GameObject target_pos.x, target_pos.y, sprite), sprite
    @speed_multiplier = 100
    @damage = 1 / 10

  update: (dt) =>
    if not @alive
      return
    if not @target
      @health = 0
    if not @isOnScreen!
      @health = 0
      return

    super dt

    target = MainPlayer\getHitBox!
    bullet = @getHitBox!
    bullet.radius += @attack_range
    if target\contains bullet
      MainPlayer\onCollide @
      MusicPlayer\play @death_sound
      @kill!

  draw: =>
    super!
    if DEBUGGING
      love.graphics.setShader!
      setColor 0, 127, 127, 200
      love.graphics.circle "fill", @target.position.x, @target.position.y, 20, 360
