export class RangedBow extends Weapon
  new: (player) =>
    sprite = Sprite "unused/wormhole.tga", 40, 40, 1, 1
    sprite.color = {255, 120, 200, 255}
    action = (x, y, button, isTouch) =>
      if button != 1 return
      @used = true
      bullet_speed = Vector x - @player.position.x, y - @player.position.y, true
      bullet_speed = bullet_speed\multiply 400
      bullet = FilteredBullet @player.position.x, @player.position.y, @damage, bullet_speed, {EntityTypes.enemy, EntityTypes.boss}
      bullet.sprite = Sprite "weapon/arrow.tga", 27, 28, 1, 1.75
      bullet.bow = @
      bullet.old_kill = bullet.kill
      bullet.kill = () =>
        @old_kill!
        @bow.used = false
      trail_sprite = bullet.sprite\getCopy!
      bullet.trail = ParticleTrail bullet.position.x - Screen_Size.half_width, bullet.position.y - Screen_Size.half_height, trail_sprite, bullet
      Driver\addObject bullet, EntityTypes.bullet
      Driver\addObject bullet.trail, EntityTypes.particle
      Timer 0.5, @, (() =>
        @parent.used = false
        Driver\removeObject @parent.trail
      ), false
      Timer 4, @, (() =>
        Driver\removeObject bullet
        Driver\removeObject bullet.trail
      ), false
    super player, sprite, action
    @damage = 3
