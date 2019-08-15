export class MagicFireball extends Weapon
  new: (player) =>
    sprite = Sprite "weapon/fireballMini.tga", 32, 32
    super player, sprite

  calcDamage: =>
    return @player.stats.intelligence * 0.25

  action: (x, y, button, isTouch) =>
    if button != 1 return
    @used = true
    bullet_speed = Vector x - @player.position.x, y - @player.position.y, true
    bullet_speed = bullet_speed\multiply 400
    bullet = FilteredBullet @player.position.x, @player.position.y, @damage, bullet_speed, {EnemyHandler, BossHandler}
    bullet.sprite = Sprite "weapon/fireball.tga", 32, 32, 1, 1.5
    bullet.parent = @
    bullet.old_kill = bullet.kill
    bullet.kill = () =>
      @old_kill!
      @parent.used = false
      sprite = Sprite "weapon/fireball.tga", 32, 32, 1, 5
      particle = EnemyPoisonParticle @position.x - Screen_Size.half_width, @position.y - Screen_Size.half_height, sprite, 255, 0, 1
      particle.damage = @damage / 2
    trail_sprite = bullet.sprite\getCopy!
    bullet.trail = ParticleTrail bullet.position.x - Screen_Size.half_width, bullet.position.y - Screen_Size.half_height, trail_sprite, bullet
    Timer 0.5, @, (() =>
      @parent.used = false
    ), false
    Timer 2, @, (() =>
      bullet.health = 0
    ), false
