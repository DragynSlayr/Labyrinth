export class Enemy extends GameObject
  new: (x, y, sprite, attack_delay, attack_speed, target = nil) =>
    super x, y, sprite
    @target = target
    bounds = @sprite\getBounds 0, 0
    @attack_range = bounds.radius * 2
    @delay = attack_delay
    @max_speed = 150 * Scale.diag
    @speed_multiplier = @max_speed
    @value = 1
    @attacked_once = false
    @corner_target = true
    @item_drop_chance = 0.10

    sprite_copy = sprite\getCopy!
    sprite_copy\setColor {50, 50, 50, 255}
    @trail = nil--ParticleTrail x, y, sprite_copy, @

    splitted = split @normal_sprite.name, "."
    name = splitted[1] .. "Action." .. splitted[2]
    height, width, _, scale = @normal_sprite\getProperties!

    @action_sprite = ActionSprite name, height, width, attack_speed, scale, @, () =>
      target = @parent.target\getHitBox!
      if @parent.target.getAttackHitBox
        target = @parent.target\getAttackHitBox!
      enemy = @parent\getHitBox!
      enemy.radius += @parent.attack_range
      if target\contains enemy
        @parent.elapsed = 0
        @parent.target\onCollide @parent
        @parent.speed_multiplier = 0
        if @parent.target.health <= 0
          @parent\findNearestTarget!

    @death_sound = 0

    EnemyHandler\add @

  kill: =>
    super!
    MusicPlayer\play @death_sound

  __tostring: =>
    return "Enemy"

  update: (dt, search = false) =>
    if not @alive return
    @findNearestTarget search
    if not @target return
    dist = @position\getDistanceBetween @target.position
    if dist < Screen_Size.width / 4 or not @corner_target
      @speed = Vector @target.position.x - @position.x, @target.position.y - @position.y
      @speed\toUnitVector!
      @speed = @speed\multiply clamp @speed_multiplier, 0, @max_speed
      @speed_multiplier += 1
      super dt
      vec = Vector 0, 0
      @sprite.rotation = @speed\getAngleBetween vec
      if not @target return
      target = @target\getHitBox!
      if @target.getAttackHitBox
        target = @target\getAttackHitBox!
      enemy = @getHitBox!
      enemy.radius += @attack_range
      can_attack = target\contains enemy
      if can_attack
        if @attacked_once
          if @elapsed >= @delay
            @sprite = @action_sprite
        else
          @sprite = @action_sprite
          @attacked_once = true
    else
      @speed = Vector @target.position.x - @position.x, @target.position.y - @position.y
      length = @speed\getLength!
      x = @speed.x / length
      y = @speed.y / length
      diff = math.abs x - y
      if diff <= 1.3 and diff >= 0.05
        copy = @speed\getAbsolute!
        --print @speed\__tostring! .. ", " .. copy\__tostring!
        if copy.x > copy.y
          @speed = Vector @speed.x, 0
        elseif copy.x < copy.y
          @speed = Vector 0, @speed.y
      @speed\toUnitVector!
      @speed = @speed\multiply clamp @speed_multiplier, 0, @max_speed
      @speed_multiplier += 1
      super dt
      vec = Vector 0, 0
      @sprite.rotation = @speed\getAngleBetween vec

  draw: =>
    if not @alive return
    if DEBUGGING
      setColor 255, 0, 255, 127
    if @sprite == @action_sprite
      alpha = map @action_sprite.current_frame, 1, @action_sprite.frames, 100, 255
      setColor 255, 0, 0, alpha
    if DEBUGGING --or @sprite == @action_sprite
      @getHitBox!\draw!
    super!

  findNearestTarget: (all = false) =>
    @target = MainPlayer
