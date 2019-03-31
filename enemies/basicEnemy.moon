export class BasicEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/tracker.tga", 32, 32, 1, 1.25
    attack_speed = math.max 0.5, 0.75 - (0.01 * Objectives\getScaling!)
    super x, y, sprite, 1, attack_speed
    @enemyType = EnemyTypes.basic
    @score_value = 100
    @exp_given = @score_value + (@score_value * 0.25 * Objectives\getLevel!)

    @health = 12 + (30 * Objectives\getScaling!)
    @max_health = @health
    @max_speed = 175 * Scale.diag--math.min 500 * Scale.diag, (175 + (54 * Objectives\getScaling!)) * Scale.diag
    @speed_multiplier = @max_speed
    @damage = 1--math.min 37, 1 + (6 * Objectives\getScaling!)

    sound = Sound "basic_enemy_death.ogg", 0.75, false, 1.5, true
    @death_sound = MusicPlayer\add sound

  __tostring: =>
    return "T: " .. @enemyType .. "\tH: " .. @max_health .. "\tD: " .. @damage .. "\tS: " .. @max_speed
