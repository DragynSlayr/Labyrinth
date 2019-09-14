export class GameObject
  new: (x, y, sprite, x_speed = 0, y_speed = 0) =>
    @position = Vector x + Screen_Size.half_width, y + Screen_Size.half_height
    @speed = Vector x_speed, y_speed
    @sprite = sprite
    @elapsed = 0
    @health = 5
    @max_health = @health
    @damage = 1
    @alive = true
    @draw_health = true
    @score_value = 0
    @exp_given = 0
    @shielded = false
    @shield_timer = 0
    @max_shield_time = 7

    @solid = true
    @colliders = {}
    @last_position = Vector @position\getComponents!

    @contact_damage = false
    @item_drop_chance = 0.00

    @speed_override = false
    @speed_add = Vector 0, 0
    @speed_override_ratio = 0

    @normal_sprite = @sprite
    @action_sprite = @sprite

    @shield_sprite = Sprite "item/shield.tga", 32, 32, 1, 1
    x_scale = @sprite.scaled_width / 32
    y_scale = @sprite.scaled_height / 32
    @shield_sprite\setScale x_scale * 1.5, y_scale * 1.5

    @setArmor 0, @max_health

    @slagged = false
    @slagging = false
    @slag_timer = 0
    @max_slag_time = 2

    @knockback = false

    @movement_disabled = false
    @movement_disabled_sprite = Sprite "effect/emp.tga", 32, 32, 1, 1
    x_scale = @sprite.scaled_width / 32
    y_scale = @sprite.scaled_height / 32
    @movement_disabled_sprite\setScale x_scale * 1.5, y_scale * 1.5

    @charmed = false

    @health_drain_rate = 0

  setSpeedOverride: (new_speed, ratio) =>
    x, y = new_speed\getComponents!
    @speed_add = Vector x, y, true
    @speed_override_ratio = ratio
    @speed_override = true

  setArmor: (armor, max_armor) =>
    @armor = armor
    @max_armor = max_armor
    @armored = @armor > 0

  getHitBox: =>
    -- Get the radius of this Sprite as the minimum of height and width
    radius = math.min @sprite.scaled_height / 2, @sprite.scaled_width / 2

    -- Return a new Circle at this x and y with the radius
    return Circle @position.x, @position.y, radius

  onCollide: (object) =>
    if not @alive return
    if not @shielded
      damage = object.damage
      if @slagged
        damage *= 1.5
      if @armored
        @armor -= damage
        if @armor <= 0
          @health += @armor
        @armored = @armor > 0
      else
        @health -= damage
      if object.slagging
        @slagged = true
      if object.knockback
        x, y = object.speed\getComponents!
        speed = Vector x, y, true
        @position\add speed\multiply (Scale.diag * 10)
        radius = @getHitBox!.radius
      @health = clamp @health, 0, @max_health
      @armor = clamp @armor, 0, @max_armor

  kill: =>
    ScoreTracker\addScore @score_value
    @alive = false
    @health = 0

  mousepressed: (x, y, button, isTouch) =>
    return false

  mousereleased: (x, y, button, isTouch) =>
    return false

  update: (dt) =>
    if not @alive return
    if @shielded
      @shield_timer += dt
      @shield_sprite\update dt
      if @shield_timer >= @max_shield_time
        @shield_timer = 0
        @shielded = false
    @sprite\update dt
    @health = clamp @health, 0, @max_health
    @armor = clamp @armor, 0, @max_armor
    @armored = @armor > 0
    if @slagged
      @slag_timer += dt
      if @slag_timer >= @max_slag_time
        @slagged = false
        @slag_timer = 0
    start = Vector @position.x, @position.y
    @elapsed += dt
    start_speed = Vector @speed\getComponents!
    if @speed_override
      speed = @speed_add\multiply @speed\getLength! * @speed_override_ratio
      @speed\add speed
      @speed = @speed\multiply 0.5
    if @movement_disabled
      @movement_disabled_sprite\update dt
    else
      @position\add @speed\multiply dt

    radius = @getHitBox!.radius

    @health -= @health_drain_rate

  draw: =>
    if not @isOnScreen! return
    old_color = @sprite.color
    if @charmed
      @sprite.color = {200, 0, 127}
    if @slagged
      @sprite.color[2] = 0
    @sprite\draw @position.x, @position.y
    @sprite.color = old_color
    if @movement_disabled
      @movement_disabled_sprite\draw @position.x, @position.y
    -- Draw bounds if debugging
    if DEBUGGING
      @getHitBox!\draw!
    if @draw_health
      love.graphics.setShader Driver.shader
      setColor 0, 0, 0, 255
      radius = @sprite.scaled_height / 2
      love.graphics.rectangle "fill", (@position.x - radius) - (3 * Scale.width), (@position.y + radius) + (3 * Scale.height), (radius * 2) + (6 * Scale.width), 16 * Scale.height
      setColor 0, 255, 0, 255
      ratio = @health / @max_health
      love.graphics.rectangle "fill", @position.x - radius, (@position.y + radius) + (6 * Scale.height), (radius * 2) * ratio, 10 * Scale.height
      if @armored
        setColor 0, 127, 255, 255
        ratio = @armor / @max_armor
        love.graphics.rectangle "fill", @position.x - radius, (@position.y + radius) + (6 * Scale.height), (radius * 2) * ratio, 10 * Scale.height
      love.graphics.setShader!
    if @shielded
      @shield_sprite\draw @position.x, @position.y

  isOnScreen: () =>
    if not @alive return false
    circle = @getHitBox!
    x, y = circle.center\getComponents!
    radius = circle.radius
    return Camera\isOnScreen x, y, radius, radius
