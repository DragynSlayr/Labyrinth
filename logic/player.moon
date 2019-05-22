export class Player extends GameObject
  new: (x, y) =>
    sprite = Sprite "player/test.tga", 16, 16, 2, 4
    super x, y, sprite
    @sprite\setRotationSpeed -math.pi / 2

    @colliders = {EntityTypes.enemy, EntityTypes.boss}

    @setBaseStats!

    @keys_pushed = 0
    @hit = false
    @attack_timer = 0

    @id = EntityTypes.player
    @draw_health = false

    @font = Renderer\newFont 20

    @range_boost = 0
    @speed_boost = 0
    @speed_range = @sprite\getBounds!.radius + (150 * Scale.diag)
    @charged = true

    @equipped_items = {}

    @knocking_back = false
    @knock_back_sprite = Sprite "projectile/knockback.tga", 26, 20, 1, 0.75
    @movement_blocked = false
    @lock_sprite = Sprite "effect/lock.tga", 32, 32, 1, 1.75
    @draw_lock = true

    @show_stats = true
    @is_clone = false
    @can_shoot = true

    @position = Camera.position

  setBaseStats: =>
    @lives = 1
    @damage = Stats.player[3]
    @max_speed = Stats.player[4]
    @max_health = Stats.player[1]
    @attack_range = Stats.player[2]
    @attack_speed = Stats.player[5]
    @health = @max_health
    @setArmor 0, @max_health
    @bullet_speed = @max_speed * 1.25

  getStats: =>
    stats = {}
    stats[1] = @max_health
    stats[2] = @attack_range
    stats[3] = @damage
    stats[4] = @max_speed
    stats[5] = @attack_speed
    return stats

  hasItem: (itemType) =>
    for k, v in pairs @equipped_items
      if (v.__class == itemType)
        return true
    return false

  kill: =>
    @lives -= 1
    if @lives <= 0
      super!
      Driver.game_over!
    else
      @health = @max_health
      @shielded = true
      Driver\addObject @, EntityTypes.player

  onKill: (entity) =>
    for k, i in pairs @equipped_items
      i\onKill entity

  onCollide: (object) =>
    if not @alive return

    if object.id == EntityTypes.item
      object\pickup @
      return
    if not @shielded
      damage = object.damage
      if @slagged
        damage *= 2
      if @armored
        @armor -= damage
        if @armor <= 0
          @health += @armor
        @armored = @armor > 0
      else
        damage = object.damage
        @health -= damage
        @hit = true
      if object.slagging
        @slagged = true
    @health = clamp @health, 0, @max_health
    @armor = clamp @armor, 0, @max_armor

  keypressed: (key) =>
    if not @alive or @is_clone return

    if not @movement_blocked
      @last_pressed = key
      if key == Controls.keys.MOVE_LEFT
        @speed.x -= @max_speed
      elseif key == Controls.keys.MOVE_RIGHT
        @speed.x += @max_speed
      elseif key == Controls.keys.MOVE_UP
        @speed.y -= @max_speed
      elseif key == Controls.keys.MOVE_DOWN
        @speed.y += @max_speed
      for k, v in pairs {Controls.keys.MOVE_LEFT, Controls.keys.MOVE_RIGHT, Controls.keys.MOVE_UP, Controls.keys.MOVE_DOWN}
        if key == v
          @keys_pushed += 1

    if key == Controls.keys.USE_ITEM
      for k, v in pairs @equipped_items
        v\use!

  keyreleased: (key) =>
    if not @alive return

    if not @movement_blocked
      @last_released = key
      if @keys_pushed > 0
        if key == Controls.keys.MOVE_LEFT
          @speed.x += @max_speed
        elseif key == Controls.keys.MOVE_RIGHT
          @speed.x -= @max_speed
        elseif key == Controls.keys.MOVE_UP
          @speed.y += @max_speed
        elseif key == Controls.keys.MOVE_DOWN
          @speed.y -= @max_speed
        for k, v in pairs {Controls.keys.MOVE_LEFT, Controls.keys.MOVE_RIGHT, Controls.keys.MOVE_UP, Controls.keys.MOVE_DOWN}
          if key == v
            @keys_pushed -= 1

  move: (dt) =>
    if @keys_pushed == 0 or @movement_blocked
      @speed = Vector 0, 0
      return false, 0
    else
      start = Vector @speed\getComponents!
      if @speed\getLength! > @max_speed
        @speed = @speed\multiply 1 / (math.sqrt 2)
      boost = Vector @speed_boost, 0
      angle = @speed\getAngle!
      boost\rotate angle
      @speed\add boost
      return true, start

  calculateBulletSpeed: =>
    bullet_speed = Vector 0, 0
    if love.keyboard.isDown Controls.keys.SHOOT_LEFT
      bullet_speed\add (Vector -@bullet_speed, 0)
    if love.keyboard.isDown Controls.keys.SHOOT_RIGHT
      bullet_speed\add (Vector @bullet_speed, 0)
    if love.keyboard.isDown Controls.keys.SHOOT_UP
      bullet_speed\add (Vector 0, -@bullet_speed)
    if love.keyboard.isDown Controls.keys.SHOOT_DOWN
      bullet_speed\add (Vector 0, @bullet_speed)
    return bullet_speed, bullet_speed\getLength! > 0

  update: (dt) =>
    @position\add (Vector Screen_Size.half_width, Screen_Size.half_height)

    if not @alive return

    for k, i in pairs @equipped_items
      i\update dt

    resetSpeed, start = @move dt
    super dt
    Camera\moveTo @position
    if resetSpeed
      @speed = start
    @speed_boost = 0

    @lock_sprite\update dt

    @attack_timer += dt
    attacked = false
    filters = {EntityTypes.enemy, EntityTypes.boss}
    if @attack_timer >= @attack_speed
      bullet_speed, should_fire = @calculateBulletSpeed!
      if should_fire and @can_shoot
        bullet = @createBullet @position.x, @position.y, @damage, bullet_speed, filters
        bullet.max_dist = (@getHitBox!.radius + (2 * (@attack_range + @range_boost)))
        if @knocking_back
          bullet.sprite = @knock_back_sprite
          bullet.knockback = true
        Driver\addObject bullet, EntityTypes.bullet
        attacked = true

    if attacked
      @attack_timer = 0

    @position\add ((Vector Screen_Size.half_width, Screen_Size.half_height)\multiply -1)
  
  createBullet: (x, y, damage, speed, filters) =>
    return FilteredBullet x, y, damage, speed, filters

  drawPlayerStats: =>
    Camera\unset!
    setColor 0, 0, 0, 255
    love.graphics.setFont @font

    y_start = Screen_Size.height - (60 * Scale.height)

    setColor 0, 0, 0, 255
    love.graphics.rectangle "fill", Screen_Size.half_width - (200 * Scale.width), y_start, 400 * Scale.width, 20 * Scale.height
    setColor 255, 0, 0, 255
    ratio = @health / @max_health
    love.graphics.rectangle "fill", Screen_Size.half_width - (197 * Scale.width), y_start + (3 * Scale.height), 394 * ratio * Scale.width, 14 * Scale.height
    if @armored
      setColor 0, 127, 255, 255
      ratio = @armor / @max_armor
      love.graphics.rectangle "fill", Screen_Size.half_width - (197 * Scale.width), y_start + (3 * Scale.height), 394 * ratio * Scale.width, 14 * Scale.height

    love.graphics.setFont @font
    setColor 0, 0, 0, 255
    x_offset = 325 * Scale.width

    limit = (@font\getWidth ".") * 17

    y = y_start + (1.5 * Scale.height)
    love.graphics.printf "Health", Screen_Size.half_width - x_offset, y, limit, "left"
    health = string.format "%.2f/%.2f HP", (@health + @armor), @max_health
    love.graphics.printf health, Screen_Size.half_width + (x_offset * 0.75), y, limit, "left"

    Camera\set!

  draw: =>
    if not @alive return
    @position\add (Vector Screen_Size.half_width, Screen_Size.half_height)
    for k, i in pairs @equipped_items
      i\draw!
    if DEBUGGING
      setColor 0, 0, 255, 100
      player = @getHitBox!
      love.graphics.circle "fill", @position.x, @position.y, @attack_range + player.radius + @range_boost, 360
      setColor 0, 255, 0, 100
      love.graphics.circle "fill", @position.x, @position.y, @speed_range, 360
    super!
    if @movement_blocked and @draw_lock
      @lock_sprite\draw @position.x, @position.y

    if @show_stats
      @drawPlayerStats!
    @position\add ((Vector Screen_Size.half_width, Screen_Size.half_height)\multiply -1)
