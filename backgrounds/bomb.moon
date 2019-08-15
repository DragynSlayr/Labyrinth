export class Bomb extends BackgroundObject
  new: (x, y) =>
    sprite = Sprite "background/bomb.tga", 32, 32, 1, 2
    super x, y, sprite

    @max_time = 0
    @attack_range = 100 * Scale.diag
    @action_sprite = ActionSprite "background/bombAction.tga", 32, 32, 3, 2, @, () =>
      filters = {EnemyHandler, BossHandler}
      for k2, filter in pairs filters
        for k, e in pairs filter.objects
          target = e\getHitBox!
          bomb = @parent\getHitBox!
          bomb.radius += @parent.attack_range
          if target\contains bomb
            @parent.damage = e.max_health / 2
            e\onCollide @parent
      @parent\kill!

  update: (dt) =>
    super dt
    if @elapsed >= @max_time
      @sprite = @action_sprite

  draw: =>
    love.graphics.push "all"
    love.graphics.setShader Driver.shader
    color = map @action_sprite.current_frame, 1, @action_sprite.frames, 200, 0
    setColor color, color, color, 127
    bounds = @getHitBox!
    love.graphics.circle "fill", @position.x, @position.y, bounds.radius + @attack_range, 360
    love.graphics.setShader!
    love.graphics.pop!
    super!
