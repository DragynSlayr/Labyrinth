export class MagicLightning extends Weapon
  new: (player) =>
    sprite = Sprite "unused/wormhole.tga", 40, 40, 1, 1
    sprite.color = {100, 20, 255, 255}
    super player, sprite
    @damage = 3

  action: (x, y, button, isTouch) =>
    if button != 1 return
    @used = true
    bullet_speed = Vector x - @player.position.x, y - @player.position.y, true
    @make_lightning @player.position, bullet_speed, 3
    Timer 1.5, @, (() =>
      @parent.used = false
    ), false

  make_lightning: (position, speed, depth) =>
    spread = ({math.pi / 6, math.pi / 8, math.pi / 16})[depth]
    rotations = {-spread, spread, spread}
    lens = {2, 4, 3}
    len_cap = lens[depth]
    times = {0.052, 0.0515, 0.051}
    timing = times[depth]
    total_time = 0.0
    for i, num in pairs lens
      total_time += num * times[i]
    for i, rotation in pairs rotations
      speed\rotate rotation
      for i = 1, len_cap
        t = Timer (i * timing), @, (() =>
          sprite = Sprite "weapon/lightning.tga", 32, 18, 1, 1
          sprite\setScale 0.5, 1.3
          height = sprite.scaled_height * 0.99
          sprite\setRotation (@speed\getAngle! + (math.pi / 2))
          @position\add (@speed\multiply ((i - 0.5) * height))
          particle = EnemyPoisonParticle @position.x - Screen_Size.half_width, @position.y - Screen_Size.half_height, sprite, 0, 255, total_time * 1.2
          particle.damage = @parent.damage / 4
          particle.oldHB = particle.getHitBox
          particle.getHitBox = () =>
            hb = @oldHB!
            hb.radius *= 3
            return hb
          Driver\addObject particle, EntityTypes.particle
          if i == len_cap and depth != 1
            t = Timer 0, @, (() =>
              @parent.parent\make_lightning @position, @speed, (depth - 1)
            ), false
            t.position = @position\getCopy!
            t.speed = @speed\getCopy!
        ), false
        t.speed = speed\getCopy!
        t.position = position\getCopy!
