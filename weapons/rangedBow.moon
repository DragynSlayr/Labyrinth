export class RangedBow extends Weapon
  new: (player) =>
    sprite = Sprite "weapon/arrowMini.tga", 28, 28
    super player, sprite

  calcDamage: =>
    return @player.stats.dexterity * 0.6

  action: (x, y, button, isTouch) =>
    if button != 1 return
    @used = true
    bullet_speed = Vector x - @player.position.x, y - @player.position.y, true
    bullet_speed = bullet_speed\multiply 400
    bullet = FilteredBullet @player.position.x, @player.position.y, @damage, bullet_speed, {EnemyHandler, BossHandler}
    bullet.sprite = Sprite "weapon/arrow.tga", 27, 28, 1, 1
    bullet.sprite\setScale 1.2, 2
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
