export class PlayerBullet extends HomingProjectile
  new: (x, y, target, damage) =>
    sprite = Sprite "enemy/bullet.tga", 26, 20, 1, 0.5
    super x, y, target, sprite
    @damage = damage
    @trail = nil

    sound = Sound "player_bullet.ogg", 0.025, false, 1.125, true
    @death_sound = MusicPlayer\add sound

  kill: =>
    super!
    for k, p in pairs Driver.objects[EntityTypes.player]
      if p\hasItem (LifeStealPassive)
        p.health += Stats.player[3] * 0.01
        p.health = math.min p.health, p.max_health
