export class PlayerEnemy extends BasicEnemy
  new: (x, y) =>
    super x, y
    @sprite = Sprite "enemy/enemy.tga", 26, 26, 1, 0.75
    @normal_sprite = @sprite
    @createActionSprite!

    sound = Sound "player_enemy_death.ogg", 2.0, false, 1.25, true
    @death_sound = MusicPlayer\add sound
