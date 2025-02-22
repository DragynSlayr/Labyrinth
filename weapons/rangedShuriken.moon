export class RangedShuriken extends Weapon
  new: (player) =>
    sprite = Sprite "weapon/shurikenMini.tga", 62, 62
    super player, sprite

  calcDamage: =>
    return @player.stats.dexterity * 0.6

  action: (x, y, button, isTouch) =>
    if button != 1 return
    @used = true
    bullet_speed = Vector x - @player.position.x, y - @player.position.y, true
    bullet_speed = bullet_speed\multiply 400
    bullet = FilteredBullet @player.position.x, @player.position.y, @damage, bullet_speed, {EnemyHandler, BossHandler}
    bullet.fix_rotation = false
    bullet.sprite = Sprite "weapon/shuriken.tga", 62, 62, 1, 0.75
    bullet.sprite\setRotationSpeed math.pi
    bullet.bow = @
    bullet.old_kill = bullet.kill
    bullet.kill = () =>
      @old_kill!
      @bow.used = false
    trail_sprite = bullet.sprite\getCopy!
    bullet.trail = ParticleTrail bullet.position.x - Screen_Size.half_width, bullet.position.y - Screen_Size.half_height, trail_sprite, bullet
    Timer 0.5, @, (() =>
      @parent.used = false
    ), false
    Timer 4, @, (() =>
      bullet.health = 0
    ), false
    Timer 0.5, @, (() =>
      bullet.speed = bullet.speed\multiply 0.8
      bullet.sprite\setRotationSpeed (bullet.sprite.rotation_speed * 0.8)
    )
