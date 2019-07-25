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
    Timer 0.5, @, (() =>
      @parent.used = false
    ), false

  make_lightning: (position, speed, depth) =>
    if depth <= 0 return
    spread = math.pi / 8
    rotations = {-spread, spread, spread}
    len_cap = depth * 2
    for i, rotation in pairs rotations
      speed\rotate rotation
      for i = 1, len_cap
        t = Timer (i * 0.15), @, (() =>
          sprite = Sprite "weapon/lightning.tga", 32, 18, 1, 1
          sprite\setScale 1, 1.5
          height = sprite.scaled_height * 0.9
          sprite\setRotation (@speed\getAngle! + (math.pi / 2))
          @position\add (@speed\multiply (i * height))
          particle = EnemyPoisonParticle @position.x - Screen_Size.half_width, @position.y - Screen_Size.half_height, sprite, 255, 127, 1.75
          particle.damage = @parent.damage / 4
          Driver\addObject particle, EntityTypes.particle
          if i == len_cap
            @parent\make_lightning @position, @speed, (depth - 1)
        ), false
        t.speed = speed\getCopy!
        t.position = position\getCopy!
