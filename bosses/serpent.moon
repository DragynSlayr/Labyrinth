export class BossSerpent extends Boss
  new: (x, y) =>
    sprite = Sprite "boss/serpent/head.tga", 50, 55, 1, 60 / 50
    sprite\setColor {127, 200, 127, 255}
    super x, y, sprite
    @bossType = BossTypes.serpent
    @score_value = 1000
    @exp_given = @score_value + (@score_value * 0.25 * Objectives\getLevel!)

    @num_parts = 250
    @separation_distance = 15 * Scale.diag

    @health = 1000
    @max_health = @health
    @max_speed = 250
    @speed_multiplier = @max_speed
    @damage = 0.02 / @num_parts

    @ai_phase = 1
    @ai_time = 0

    @body_sprite = Sprite "boss/serpent/body.tga", 48, 48, 1, 60 / 48
    @tail_sprite = Sprite "boss/serpent/tail.tga", 48, 96, 1, 60 / 48

    @attack_range = 50 * Scale.diag

    @target = MainPlayer

    @parts = {}

    angle = (2 * math.pi) / (@num_parts + 1)

    for i = 1, @num_parts
      part = {}
      v = Vector 0, -1
      v\rotate ((i - 1) * angle)
      x, y = (v\multiply Screen_Size.height * 0.33)\getComponents!
      x += Screen_Size.half_width
      y += Screen_Size.half_height
      if i == 1
        @position = Vector x, y
      part.position = Vector x, y
      if i > 1
        part.following = @parts[i - 1]
      table.insert @parts, part

    @parts[1].following = @

    @allParts = @parts
    table.insert @allParts, @

  update: (dt) =>
    @speed = Vector @target.position.x - @position.x, @target.position.y - @position.y
    if @speed\getLength! > @separation_distance
      @speed\toUnitVector!
      @speed = @speed\multiply @speed_multiplier
      @sprite.rotation = @speed\getAngle! + math.pi
    else
      old_speed = Vector @speed\getComponents!
      @speed = Vector 0, 0
      @sprite.rotation = old_speed\getAngle! + math.pi
    super dt

    @ai_time += dt

    for i = 1, @num_parts
      x = @parts[i].following.position.x - @parts[i].position.x
      y = @parts[i].following.position.y - @parts[i].position.y
      speed = Vector x, y
      if speed\getLength! > @separation_distance
        speed\toUnitVector!
        @parts[i].position\add (speed\multiply (dt * @speed_multiplier))

    boss = @getHitBox!
    boss.radius += @attack_range
    for k, part in pairs @allParts
      enemy = MainPlayer\getHitBox!
      boss.center = Point part.position\getComponents!
      if boss\contains enemy
        MainPlayer\onCollide @

  draw: =>
    for i = @num_parts, 1, -1
      part = @parts[i]
      sprite = nil
      if i >= (@num_parts * 0.95)
        sprite = @tail_sprite
        sprite.rotation = (part.position\getAngleBetween part.following.position) + (math.pi / 2)
        sprite\setColor {127, 0, 127, 255}
      else
        sprite = @body_sprite
        sprite.rotation = @sprite.rotation + math.pi
        if (i % 2) == 0
          sprite\setColor {255, 0, 127, 255}
        else
          sprite\setColor {0, 127, 255, 255}
      sprite\draw part.position\getComponents!
      if DEBUGGING
        hitbox = @getHitBox!
        hitbox.center = Point part.position\getComponents!
        hitbox\draw!
    super!
