export class BasicEnemy extends Enemy
  new: (x, y) =>
    sprite = Sprite "enemy/tracker.tga", 32, 32, 1, 1.25
    attack_speed = 0.5
    super x, y, sprite, 1, attack_speed
    @score_value = 100
    @exp_given = @score_value

    @health = 12
    @max_health = @health
    @max_speed = 175 * Scale.diag
    @speed_multiplier = @max_speed
    @damage = 1

    sound = Sound "basic_enemy_death.ogg", 0.75, false, 1.5, true
    @death_sound = MusicPlayer\add sound
