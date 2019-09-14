export class Enemy extends GameObject
  new: (x, y, sprite, attack_delay, attack_speed) =>
    super x, y, sprite
    bounds = @sprite\getBounds 0, 0
    @attack_range = bounds.radius * 2
    @delay = attack_delay
    @max_speed = 150 * Scale.diag
    @attacked_once = false
    @trail = nil
    @death_sound = 0

    @start_position = @position\getCopy!
    @target = @start_position\getCopy!
    @roam_radius = 300 * Scale.diag
    @aggro_radius = 200 * Scale.diag
    @chase_radius = 350 * Scale.diag

    @phases = {}
    @phases.ROAMING = 1
    @phases.CHASING = 2
    @ai_phase = @phases.ROAMING

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

    EnemyHandler\add @

  kill: =>
    super!
    MusicPlayer\play @death_sound

  __tostring: =>
    return "Enemy"

  update: (dt, search = false) =>
    if not @alive return
    switch @ai_phase
      when @phases.ROAMING
        if (@position\getDistanceBetween @target) <= 10
          @target = getRandomUnitStart @roam_radius
          @target\add @start_position
        @speed = Vector @target.x - @position.x, @target.y - @position.y, true
        @speed = @speed\multiply (@max_speed * 0.75)
        super dt
        @sprite.rotation = @speed\getAngleBetween (Vector!)
        if (MainPlayer.position\getDistanceBetween @position) <= (@aggro_radius + @getHitBox!.radius)
          @ai_phase = @phases.CHASING
      when @phases.CHASING
        @target = MainPlayer.position
        @speed = Vector @target.x - @position.x, @target.y - @position.y, true
        @speed = @speed\multiply @max_speed
        super dt
        @sprite.rotation = @speed\getAngleBetween (Vector!)
        enemy = @getHitBox!
        enemy.radius += @attack_range
        if (MainPlayer\getHitBox!\contains enemy)
          if @attacked_once
            if @elapsed >= @delay
              @sprite = @action_sprite
          else
            @sprite = @action_sprite
            @attacked_once = true
        if (@position\getDistanceBetween @start_position) >= (@roam_radius + @chase_radius)
          @target = @start_position
          @ai_phase = @phases.ROAMING

  draw: =>
    if not @alive return
    if DEBUGGING
      setColor 255, 0, 255, 127
    if @sprite == @action_sprite
      alpha = map @action_sprite.current_frame, 1, @action_sprite.frames, 100, 255
      setColor 255, 0, 0, alpha
    if DEBUGGING
      @getHitBox!\draw!
    super!
