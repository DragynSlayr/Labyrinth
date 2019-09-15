export class Enemy extends GameObject
  new: (x, y, sprite, attack_delay, attack_speed) =>
    super x, y, sprite
    bounds = @sprite\getBounds 0, 0
    @attack_range = bounds.radius * 2
    @delay = attack_delay
    @max_speed = 150 * Scale.diag
    @speed_multiplier = @max_speed
    @attacked_once = false
    @trail = nil
    @death_sound = 0

    @start_position = @position\getCopy!
    @target = @start_position\getCopy!
    @roam_radius = 300 * Scale.diag
    @aggro_radius = 200 * Scale.diag
    @chase_radius = 350 * Scale.diag

    @ai_phase = 1

    @createActionSprite!

    EnemyHandler\add @

  createActionSprite: =>
    splitted = split @normal_sprite.name, "."
    name = splitted[1] .. "Action." .. splitted[2]
    height, width, _, scale = @normal_sprite\getProperties!

    @action_sprite = ActionSprite name, height, width, attack_speed, scale, @, () =>
      target = MainPlayer\getHitBox!
      enemy = @parent\getHitBox!
      enemy.radius += @parent.attack_range
      if target\contains enemy
        @parent.elapsed = 0
        MainPlayer\onCollide @parent
        @parent.speed_multiplier = 0

  kill: =>
    super!
    if @trail
      @trail.health = 0
    MusicPlayer\play @death_sound

  __tostring: =>
    return "Enemy"

  moveToTarget: (dt, speed_multiplier = 1.0) =>
    @speed = Vector @target.x - @position.x, @target.y - @position.y, true
    multiplier = clamp (speed_multiplier * @speed_multiplier), 0, @max_speed
    @speed = @speed\multiply multiplier
    @speed_multiplier += 1
    super\update dt
    @sprite.rotation = @speed\getAngleBetween (Vector!)

  tryAttack: =>
    enemy = @getHitBox!
    enemy.radius += @attack_range
    if (MainPlayer\getHitBox!\contains enemy)
      if @attacked_once
        if @elapsed >= @delay
          @sprite = @action_sprite
      else
        @sprite = @action_sprite
        @attacked_once = true

  update: (dt, search = false) =>
    if @ai_phase == 1
      if (@position\getDistanceBetween @target) <= 10
        @target = getRandomUnitStart @roam_radius
        @target\add @start_position
      @moveToTarget dt, 0.75
      near_player = (MainPlayer.position\getDistanceBetween @position) <= (@aggro_radius + @getHitBox!.radius)
      player_in = (MainPlayer.position\getDistanceBetween @start_position) <= @roam_radius
      if near_player and player_in
        @ai_phase = 2
    else if @ai_phase == 2 or @sprite == @action_sprite
      @target = MainPlayer.position
      @moveToTarget dt
      @tryAttack!
      if (@position\getDistanceBetween @start_position) >= (@roam_radius + @chase_radius)
        @target = @start_position
        @ai_phase = 1

  draw: =>
    if DEBUGGING
      setColor 255, 0, 255, 127
    if @sprite == @action_sprite
      alpha = map @action_sprite.current_frame, 1, @action_sprite.frames, 100, 255
      setColor 255, 0, 0, alpha
    if DEBUGGING
      @getHitBox!\draw!
    super!
