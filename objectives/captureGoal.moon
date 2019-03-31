export class CaptureGoal extends GameObject
  new: (x, y) =>
    sprite = Sprite "objective/flag.tga", 34, 16, 1, 2.5
    super x, y, sprite
    @id = EntityTypes.goal
    @goal_type = GoalTypes.capture
    @health = 10
    @max_health = @health
    @capture_amount = @health
    @draw_health = false
    @unlocked = false
    @tesseract = nil
    @timer = 0
    @attack_delay = 1 / 60
    @damage = (20 / 3) * @attack_delay
    @solid = false

  onCollide: (entity) =>
    if @unlocked
      if entity.id == EntityTypes.enemy and entity.enemyType == EnemyTypes.capture
        @capture_amount -= entity.damage
        entity.health = 0
      else
        if entity.__class == Missile
          @capture_amount += 2
        else
          @capture_amount += 2 / 60
      @capture_amount = clamp @capture_amount, 0, @max_health

  update: (dt) =>
    super dt
    @capture_amount = clamp @capture_amount, 0, @max_health
    if @tesseract and @unlocked
      @timer += dt
      if @timer >= @attack_delay
        @timer = 0
        @tesseract\onCollide @

  draw: =>
    if @tesseract and @unlocked
      ratio = @capture_amount / @max_health
      blue = math.floor (ratio * 255)
      red = 255 - blue
      setColor red, 127, blue, blue
      love.graphics.setLineWidth ratio * 20
      love.graphics.line @position.x, @position.y + (@sprite.scaled_height * 0.33), @tesseract.position.x, @tesseract.position.y

    super!
    love.graphics.push "all"
    love.graphics.setShader Driver.shader

    setColor 0, 0, 0, 255
    radius = @sprite.scaled_height / 2
    love.graphics.rectangle "fill", (@position.x - radius) - (3 * Scale.width), (@position.y + radius) + (3 * Scale.height), (radius * 2) + (6 * Scale.width), 16 * Scale.height

    setColor 0, 127, 255, 255
    ratio = @capture_amount / @max_health
    love.graphics.rectangle "fill", @position.x - radius, (@position.y + radius) + (6 * Scale.height), (radius * 2) * ratio, 10 * Scale.height

    setColor 255, 127, 0, 255
    love.graphics.rectangle "fill", @position.x - radius + ((radius * 2) * ratio), (@position.y + radius) + (6 * Scale.height), (radius * 2) * (1 - ratio), 10 * Scale.height

    love.graphics.setShader!
    love.graphics.pop!
