export class SpawnerEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/dart.tga", 17, 17, 1, 2
    attack_speed = 0.65
    super x, y, sprite, 1, attack_speed
    @score_value = 50
    @exp_given = @score_value

    @health = 12
    @max_health = @health
    @max_speed = 150 * Scale.diag
    @speed_multiplier = @max_speed
    @damage = 1

    sound = Sound "spawner_enemy_death.ogg", 0.75, false, 1.25, true
    @death_sound = MusicPlayer\add sound

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
