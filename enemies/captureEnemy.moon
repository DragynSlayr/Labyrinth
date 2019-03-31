export class CaptureEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/capture.tga", 32, 32, 1, 25 / 32
    super x, y, sprite, 0, 0
    @enemyType = EnemyTypes.capture
    @score_value = 100
    --@exp_given = @score_value + (@score_value * 0.35 * Objectives\getLevel!)
    --@solid = false
    @corner_target = false
    @colliders = {EntityTypes.player}

    @health = 5 + (12 * Objectives\getScaling!)
    @max_health = @health
    @max_speed = 300 * Scale.diag--math.min 650 * Scale.diag, (300 + (58.5 * Objectives\getScaling!)) * Scale.diag
    @speed_multiplier = @max_speed
    @damage = 10 / 3

    sound = Sound "capture_enemy_death.ogg", 0.75, false, 1.25, true
    @death_sound = MusicPlayer\add sound

    @attack_filters = {}

  __tostring: =>
    return "T: " .. @enemyType .. "\tH: " .. @max_health .. "\tD: " .. @damage .. "\tS: " .. @max_speed

  findNearestTarget: =>
    if not @target or not @target.alive
      @target = pick Driver.objects[EntityTypes.goal]
      while @target.goal_type == GoalTypes.tesseract
        @target = pick Driver.objects[EntityTypes.goal]
