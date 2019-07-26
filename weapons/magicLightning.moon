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
    Timer 5, @, (() =>
      @parent.used = false
    ), false

  make_lightning: (position, speed, depth) =>
    if depth <= 0 return
    new_positions = {}
    spread = ({math.pi / 7, math.pi / 8, math.pi / 6})[depth]
    dist = ({60, 100, 200})[depth] * Scale.diag
    rotations = {-spread, spread, spread}
    if depth != 3
      rotations = {-spread, spread * 2}
    speed_copy = speed\getCopy!
    sprite = Sprite "weapon/lightning.tga", 32, 18, 1, 1
    sprite\setScale 0.5, 1.3
    for j, rotation in pairs rotations
      speed_copy\rotate rotation
      position_copy = position\getCopy!
      bullet = FilteredBullet position_copy.x, position_copy.y, 0.5, (speed_copy\multiply 200), {}
      sprite\setRotation (speed_copy\getAngle! + (math.pi / 2))
      bullet.sprite = sprite\getCopy!
      bullet.parent = @
      bullet.max_dist = dist
      bullet.old_kill = bullet.kill
      bullet.depth = depth
      bullet.speed_copy = speed\getCopy!
      bullet.kill = () =>
        if @depth != 1
          @parent\make_lightning @position, @speed_copy, (@depth - 1)
        @old_kill!
      trail_sprite = bullet.sprite\getCopy!
      bullet.trail = ParticleTrail bullet.position.x - Screen_Size.half_width, bullet.position.y - Screen_Size.half_height, trail_sprite, bullet
      bullet.trail.particle_type = ParticleTypes.enemy_poison
      bullet.trail.life_time = 5
      bullet.trail.damage = @damage / 15
      bullet.kill_trail = false
      Driver\addObject bullet, EntityTypes.bullet
      Driver\addObject bullet.trail, EntityTypes.particle
