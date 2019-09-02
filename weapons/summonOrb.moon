export class SummonOrb extends Weapon
  new: (player) =>
    sprite = Sprite "weapon/orbMini.tga", 40, 40
    super player, sprite

  calcDamage: =>
    return @player.stats.wisdom * 0.6

  action: (x, y, button, isTouch) =>
    if button != 1 return
    @used = true
    sprite = Sprite "weapon/orb.tga", 40, 40, 1, 1
    sprite\setRotationSpeed (-math.pi / 2)
    orb = GameObject @player.position.x - Screen_Size.half_width, @player.position.y - Screen_Size.half_height, sprite
    orb.damage = @damage
    orb.base_color = sprite.color
    orb.attack_color = {255, 20, 100, 255}
    orb.delay = 2
    orb.elapsed = orb.delay
    orb.player = @player
    orb.offset = (Vector x - @player.position.x, y - @player.position.y, true)\multiply (@player.sprite.scaled_height * 1.5)
    orb.position = Vector @player.position.x, @player.position.y
    orb.position\add orb.offset
    orb.draw_health = false
    orb.update = (dt) =>
      @sprite\update dt
      @offset\rotate (dt * 4)
      speed = Vector (@player.position.x + @offset.x) - @position.x, (@player.position.y + @offset.y) - @position.y
      @position\add (speed\multiply dt)
      @elapsed += dt
      if @elapsed >= @delay
        @sprite.color = @base_color
        filters = {EnemyHandler, BossHandler}
        for k, filter in pairs filters
          for k2, o in pairs filter.objects[World.idx]
            target = o\getHitBox!
            bullet = @getHitBox!
            bullet.radius *= 5
            if target\contains bullet
              o\onCollide @
              @elapsed = 0
              @sprite.color = @attack_color
    ParticleHandler\add orb
    Timer 3, @, (() =>
      @parent.used = false
    ), false
    Timer 15, @, (() =>
      orb.health = 0
    ), false
