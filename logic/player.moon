class HeartContainer
  new: (player) =>
    @player = player

    inner_scale = 32 / 26
    outer_scale = 40 / 30
    @heart = Sprite "unused/heart.tga", 26, 26, 1, inner_scale
    @half_heart = Sprite "unused/half_heart.tga", 26, 26, 1, inner_scale
    @heart_out = Sprite "unused/heart_outline.tga", 30, 30, 1, outer_scale
    @half_heart_out = Sprite "unused/half_heart_outline.tga", 30, 30, 1, outer_scale

  update: (dt) =>
    @heart\update dt
    @half_heart\update dt
    @heart_out\update dt
    @half_heart_out\update dt

  draw: =>
    x = (@heart_out.scaled_width / 2) + 80
    y = 27.5
    xs = {}
    for i = 1, math.floor @player.max_health
      table.insert xs, x
      @heart_out\draw xs[i], y
      x += @heart_out.scaled_width + 5
    if @player.max_health > math.floor @player.max_health
      table.insert xs, x
      @half_heart_out\draw xs[#xs], y

    last_x = 0
    for i = 1, math.floor @player.health
      @heart\draw xs[i], y
      last_x = i
    if @player.health > math.floor @player.health
      @half_heart\draw xs[last_x + 1], y


class WeaponHolder
  new: (player) =>
    @player = player

    @weapons = {}
    @loadWeapons!
    @weapon_idx = math.random(1, #@weapons)

    @updateDamages!

  loadWeapons: =>
    weapons = {
      (MagicFireball),
      (MagicLightning),
      (MeleeSpear),
      (MeleeSword),
      (RangedBow),
      (RangedShuriken),
      (SummonCrystal),
      (SummonOrb)
    }
    for i, weapon in pairs weapons
      @addWeapon (weapon)

  addWeapon: (typeof) =>
    table.insert @weapons, (typeof @player)

  updateDamages: =>
    for i, weapon in pairs @weapons
      weapon\updateDamage!

  mousepressed: (x, y, button, isTouch) =>
    @weapons[@weapon_idx]\mousepressed x, y, button, isTouch

  mousereleased: (x, y, button, isTouch) =>
    @weapons[@weapon_idx]\mousereleased x, y, button, isTouch

  wheelmoved: (x, y) =>
    if y > 0
      @weapon_idx += 1
      if @weapon_idx > #@weapons
        @weapon_idx = 1
    if y < 0
      @weapon_idx -= 1
      if @weapon_idx < 1
        @weapon_idx = #@weapons

  update: (dt) =>
    @weapons[@weapon_idx]\update dt

  draw: () =>
    @weapons[@weapon_idx]\draw!


export class Player extends GameObject
  new: (x, y) =>
    sprite = Sprite "player/test.tga", 16, 16, 2, 4
    super x, y, sprite
    @sprite\setRotationSpeed -math.pi / 2

    @colliders = {EntityTypes.enemy, EntityTypes.boss, EntityTypes.wall}

    @keys_pushed = 0
    @hit = false

    @id = EntityTypes.player
    @draw_health = false

    @font = Renderer\newFont 20

    @speed_boost = 0
    @speed_range = @sprite\getBounds!.radius + (150 * Scale.diag)
    @charged = true

    @equipped_items = {}

    @movement_blocked = false
    @lock_sprite = Sprite "effect/lock.tga", 32, 32, 1, 1.75
    @draw_lock = true

    @show_stats = true
    @is_clone = false

    @coins = 0

    @stats = {}
    @stats.strength = 0
    @stats.dexterity = 0
    @stats.constitution = 0
    @stats.intelligence = 0
    @stats.wisdom = 0
    --@stats.charisma = 0

    @hearts = HeartContainer @
    @popup = nil

    Timer 1, @, () =>
      if Driver.game_state == Game_State.playing
        @parent\addExp 20

  pickClass: (num) =>
    switch num
      when 0
        @stats.strength = 5
        @stats.dexterity = 5
        @stats.constitution = 5
        @stats.intelligence = 5
        @stats.wisdom = 5
        -- @stats.charisma = 0
    @inventory = Inventory!
    @levelUp = LevelUp @
    @weapons = WeaponHolder @
    @level = 0
    @exp = 0
    @exp_chase = 0
    @nextExp = 100

  updateStats: =>
    @lives = 1
    @max_speed = 55.0 * @stats.dexterity * Scale.diag
    @max_health = 1.0 * @stats.constitution
    @health = @max_health
    -- @setArmor 0, @max_health
    @weapons\updateDamages!

  getStats: =>
    stats = {}
    stats[1] = @max_health
    stats[2] = @max_speed
    return stats

  addExp: (amount) =>
    @exp += amount
    while @exp >= @nextExp
      @exp -= @nextExp
      @level += 1
      @exp_chase = 0
      @nextExp = @nextExp + 20
      @levelUp.pointsAvailable += 1
      @popup = PopupText Screen_Size.half_width, Screen_Size.half_height, "Level Up!", 3, Renderer\newFont 30
      @popup.color = {255, 150, 255, 255}

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
      @shielded = true
      Timer 2, @, (() =>
        @parent.shielded = false
      ), false
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

  mousepressed: (x, y, button, isTouch) =>
    @levelUp\mousepressed x, y, button, isTouch

    if not (@levelUp\mouseOn x, y)
      x += Camera.position.x - Screen_Size.half_width
      y += Camera.position.y - Screen_Size.half_height
      @weapons\mousepressed x, y, button, isTouch

  mousereleased: (x, y, button, isTouch) =>
    @levelUp\mousereleased x, y, button, isTouch

    if not (@levelUp\mouseOn x, y)
      x += Camera.position.x - Screen_Size.half_width
      y += Camera.position.y - Screen_Size.half_height
      @weapons\mousereleased x, y, button, isTouch

  wheelmoved: (x, y) =>
    @weapons\wheelmoved x, y

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

  update: (dt) =>
    if not @alive return

    @inventory\update dt
    @levelUp\update dt
    @weapons\update dt

    @exp_chase += dt * (@nextExp / 20)
    @exp_chase = clamp @exp_chase, 0, @exp

    for k, i in pairs @equipped_items
      i\update dt

    resetSpeed, start = @move dt
    super dt
    if resetSpeed
      @speed = start
    @speed_boost = 0

    @lock_sprite\update dt
    @hearts\update dt

    if @popup
      @popup\update dt

  postUpdate: (dt) =>
    Camera\moveTo @position

  drawPlayerStats: =>
    Camera\unset!

    -- setColor 0, 0, 0, 255
    -- love.graphics.setFont @font
    --
    -- y_start = Screen_Size.height - (60 * Scale.height)
    --
    -- setColor 0, 0, 0, 255
    -- love.graphics.rectangle "fill", Screen_Size.half_width - (200 * Scale.width), y_start, 400 * Scale.width, 20 * Scale.height
    -- setColor 255, 0, 0, 255
    -- ratio = @health / @max_health
    -- love.graphics.rectangle "fill", Screen_Size.half_width - (197 * Scale.width), y_start + (3 * Scale.height), 394 * ratio * Scale.width, 14 * Scale.height
    -- if @armored
    --   setColor 0, 127, 255, 255
    --   ratio = @armor / @max_armor
    --   love.graphics.rectangle "fill", Screen_Size.half_width - (197 * Scale.width), y_start + (3 * Scale.height), 394 * ratio * Scale.width, 14 * Scale.height
    --
    -- love.graphics.setFont @font
    -- setColor 0, 0, 0, 255
    -- x_offset = 325 * Scale.width
    --
    -- limit = (@font\getWidth ".") * 17
    --
    -- y = y_start + (1.5 * Scale.height)
    -- love.graphics.printf "Health", Screen_Size.half_width - x_offset, y, limit, "left"
    -- health = string.format "%.2f/%.2f HP", (@health + @armor), @max_health
    -- love.graphics.printf health, Screen_Size.half_width + (x_offset * 0.75), y, limit, "left"

    @hearts\draw!

    x = 85
    y = 57.5
    height = 10
    setColor 0, 0, 0, 255
    love.graphics.rectangle "fill", x - 5, y - 5, @nextExp + 10, height + 10
    setColor 200, 200, 100, 255
    love.graphics.rectangle "fill", x, y, @exp, height
    setColor 150, 150, 50, 255
    love.graphics.rectangle "fill", x, y, @exp_chase, height

    if @popup
      @popup\draw!
      if not @popup.active
        @popup = nil

    Camera\set!

  draw: =>
    if not @alive return
    for k, i in pairs @equipped_items
      i\draw!
    super!
    if @movement_blocked and @draw_lock
      @lock_sprite\draw @position.x, @position.y

    if @show_stats
      @drawPlayerStats!

    @inventory\draw!
    @levelUp\draw!
    @weapons\draw!
