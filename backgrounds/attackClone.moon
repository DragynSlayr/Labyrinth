export class AttackClone extends BackgroundObject
  new: (player) =>
    sprite = Sprite "background/clone.tga", 32, 32, 1, 2
    sprite\setRotationSpeed math.pi / 2
    super player.position.x, player.position.y, sprite

    @max_time = 10
    @max_health = @max_time
    @attack_range = 100 * Scale.diag
    @draw_health = true

    @directions = {
      (Vector 1, 0),
      (Vector -1, 0),
      (Vector 0, 1),
      (Vector 0, -1)
    }
    @max_speed = (69 * 5) * Scale.diag
    @speed = (pick @directions)\multiply @max_speed

    @speed_time = 0.5
    @speed_timer = 0
    @bullet_time = 0.3
    @bullet_timer = 0

    @filters = {EntityTypes.enemy, EntityTypes.boss}
    for k, v in pairs Driver.objects[EntityTypes.goal]
      if v.goal_type == GoalTypes.attack
        table.insert @filters, EntityTypes.goal
        break

    @damage = player.damage
    @attack_range = player.attack_range
    @bullet_speed = player.bullet_speed

  update: (dt) =>
    @speed_timer += dt
    if @speed_timer >= @speed_time
      @speed_timer = 0
      @speed = (pick @directions)\multiply @max_speed
    @bullet_timer += dt
    if @bullet_timer >= @bullet_time
      @bullet_timer = 0
      for k, v in pairs @directions
        bullet_speed = v\multiply @bullet_speed
        bullet = FilteredBullet @position.x, @position.y, @damage, bullet_speed, @filters
        bullet.max_dist = @getHitBox!.radius + (2 * @attack_range)
        Driver\addObject bullet, EntityTypes.bullet
    super dt
    @health = (@max_time - @elapsed)

  draw: =>
    super!
