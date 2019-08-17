export class MagicLightning extends Weapon
  new: (player) =>
    sprite = Sprite "weapon/lightningMini.tga", 32, 32
    super player, sprite

  calcDamage: =>
    return @player.stats.wisdom / 50.0

  action: (x, y, button, isTouch) =>
    if button != 1 return
    @used = true
    bullet_speed = Vector x - @player.position.x, y - @player.position.y, true
    @make_lightning @player.position, bullet_speed, nil
    Timer 0.5, @, (() =>
      @parent.used = false
    ), false

  make_lightning: (position, speed, cant_hit) =>
    sprite = Sprite "weapon/lightning.tga", 32, 18, 1, 1
    sprite\setScale 0.5, 1.2
    sprite\setRotation (speed\getAngle! + (math.pi / 2))

    bullet = FilteredBullet position.x, position.y, @damage, (speed\multiply 1000), {EnemyHandler, BossHandler}
    bullet.sprite = sprite\getCopy!
    bullet.old_kill = bullet.kill
    bullet.cant_hit = cant_hit
    bullet.parent = @
    bullet.max_dist = 800 * Scale.diag
    bullet.kill = () =>
      @old_kill!
      if @target_hit
        dist = @max_dist
        closest = nil
        for k, filter in pairs @filter
          for k2, o in pairs filter.objects
            if o != @hit_target
              temp_dist = (Vector o.position.x - @hit_target.position.x, o.position.y - @hit_target.position.y)\getLength!
              if temp_dist < dist
                dist = temp_dist
                closest = o
        if closest
          speed = Vector closest.position.x - @hit_target.position.x, closest.position.y - @hit_target.position.y, true
          @parent\make_lightning @hit_target.position, speed, @hit_target

    trail_sprite = bullet.sprite\getCopy!
    bullet.trail = ParticleTrail bullet.position.x - Screen_Size.half_width, bullet.position.y - Screen_Size.half_height, trail_sprite, bullet
    bullet.trail.particle_type = ParticleTypes.enemy_poison
    bullet.trail.life_time = 10
    bullet.trail.damage = @damage
    bullet.kill_trail = true
