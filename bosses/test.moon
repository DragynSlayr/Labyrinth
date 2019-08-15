export class BossTest extends Boss
  new: (x, y) =>
    sprite = Sprite "objective/portal.tga", 56, 56, 1, 1.8
    super x, y, sprite
    @bossType = BossTypes.test
    @score_value = 1000
    @exp_given = @score_value + (@score_value * 0.25 * Objectives\getLevel!)

    @health = 1000
    @max_health = @health
    @max_speed = 225
    @speed_multiplier = @max_speed
    @damage = 0.02--0.5

    @sprite\setShader love.graphics.newShader "shaders/pulse.fs"--fader.fs"
    @sprite\setRotationSpeed -math.pi / 2

    @shader = love.graphics.newShader "shaders/distance.fs"
    @shader\send "screen_size", {Screen_Size.width, Screen_Size.height}
    @shader\send "player_pos", {MainPlayer.position.x, MainPlayer.position.y}
    @target = MainPlayer

    @ai_phase = 1
    @ai_time = 0

    @threshold = 0.1
    @fade_speed = 1.5
    @alpha = 0

  isVisible: =>
    return (((math.sin @fade_speed * @ai_time) + 1) / 2) >= @threshold

  onCollide: (object) =>
    if @isVisible!
      super object

  update: (dt) =>
    @ai_time += dt
    visible = @isVisible!
    @solid = visible
    @draw_health = visible
    @alpha = ((math.sin @fade_speed * @ai_time) + 1) / 2
    @sprite.shader\send "elapsed", ((math.sin @fade_speed * @ai_time) + 1) / 2
    @shader\send "player_pos", {@target.position.x, @target.position.y}
    switch @ai_phase
      when 1
        @speed = Vector @target.position.x - @position.x, @target.position.y - @position.y
        @speed\toUnitVector!
        @speed = @speed\multiply @speed_multiplier
        super dt
        if @ai_time >= 6
          @ai_time = 0
          @ai_phase += 1
          @speed = Vector 0, 0

          speeds = {{0, 1}, {1, 0}, {-1, 0}, {0, -1}, {1, 1}, {-1, -1}, {-1, 1}, {1, -1}}
          for k, speed in pairs speeds
            copy = @sprite\getCopy!
            copy\scaleUniformly 0.3
            b = SplitShot @position.x, @position.y, (Vector speed[1], speed[2]), 300 * Scale.diag, copy
            b.sprite\setShader love.graphics.newShader "shaders/normal.fs"
            b.sprite\setColor {255, 0, 0, 127}
            b.sprite\setRotationSpeed math.pi * 1.5
      when 2
        super dt
        if @ai_time >= 7
          @ai_time = 0
          @ai_phase = 1

          temp = Objectives\spawn (BossTest), BossHandler
          @position = temp.position
          Driver\removeObject temp, false

  draw: =>
    color = @sprite.color
    color[4] = math.ceil (@alpha * 255)
    @sprite\setColor color
    super!
