export class Missile extends HomingProjectile
  new: (x, y) =>
    sprite = Sprite "projectile/missile.tga", 32, 16, 1, 1
    sprite\scaleUniformly 1.25, 1.50
    super x, y, nil, sprite
    @damage = MainPlayer.damage * 120
    @speed_multiplier = 250
    @target = @findTarget!
    if not @target
      @kill!

    sound = Sound "player_missile.ogg", 0.25, false, 0.50, true
    @death_sound = MusicPlayer\add sound

  findTarget: =>
    targets = {}
    targets = concatTables targets, EnemyHandler.objects[World.idx]
    targets = concatTables targets, BossHandler.objects[World.idx]
    return (pick targets)
