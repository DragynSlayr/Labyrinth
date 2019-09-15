export class PlayerEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/enemy.tga", 26, 26, 1, 0.75
    attack_speed = 0.6
    super x, y, sprite, 1, attack_speed
    @score_value = 150
    @exp_given = @score_value

    @health = 6
    @max_health = @health
    @max_speed = 300 * Scale.diag
    @speed_multiplier = @max_speed
    @damage = 0.5

    sound = Sound "player_enemy_death.ogg", 2.0, false, 1.25, true
    @death_sound = MusicPlayer\add sound
