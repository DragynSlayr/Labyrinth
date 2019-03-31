export class Bullet extends HomingProjectile
  new: (x, y, target, damage) =>
    sprite = Sprite "projectile/bullet_anim.tga", 32, 16, 0.02, 0.75
    super x, y, target, sprite
    @damage = damage

    sound = Sound "turret_bullet.ogg", 0.005, false, 0.75, true
    @death_sound = MusicPlayer\add sound
