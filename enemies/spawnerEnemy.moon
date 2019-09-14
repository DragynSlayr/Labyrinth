export class SpawnerEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/dart.tga", 17, 17, 1, 2
    attack_speed = math.max 0.4, 0.65 - (0.01 * Objectives\getScaling!)
    super x, y, sprite, 1, attack_speed
    @enemyType = EnemyTypes.spawner
    @score_value = 50
    @exp_given = @score_value + (@score_value * 0.15 * Objectives\getLevel!)

    @health = 12 + (28 * Objectives\getScaling!)
    @max_health = @health
    @max_speed = 150 * Scale.diag--math.min 450 * Scale.diag, (150 + (50 * Objectives\getScaling!)) * Scale.diag
    @speed_multiplier = @max_speed
    @damage = 1--math.min 28, 1 + (4.45 * Objectives\getScaling!)

    sound = Sound "spawner_enemy_death.ogg", 0.75, false, 1.25, true
    @death_sound = MusicPlayer\add sound

  __tostring: =>
    return "T: " .. @enemyType .. "\tH: " .. @max_health .. "\tD: " .. @damage .. "\tS: " .. @max_speed

  kill: =>
    super!

    positions = {
      {-10, 0},
      {10, 0},
      {0, -10},
      {0, 10}
    }

    for k, v in pairs positions
      enemy = PlayerEnemy @position.x + v[1], @position.y + v[2]
      enemy.solid = false
