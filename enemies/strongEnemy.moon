export class StrongEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/bullet.tga", 26, 20, 1, 2
    attack_speed = 0.8
    super x, y, sprite, 1, attack_speed
    @score_value = 200
    @exp_given = @score_value

    @health = 18
    @max_health = @health
    @max_speed = 100 * Scale.diag
    @speed_multiplier = @max_speed
    @damage = 1.5

    sound = Sound "strong_enemy_death.ogg", 0.25, false, 0.13, true
    @death_sound = MusicPlayer\add sound
