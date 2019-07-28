export class MeleeSword extends Weapon
  new: (player) =>
    sprite = Sprite "weapon/swordMini.tga", 23, 23
    super player, sprite
    @damage = 0.3

  action: (x, y, button, isTouch) =>
    if button != 1 return
    @used = true
    use_time = 0.35
    sprite = Sprite "weapon/sword.tga", 31, 12, 1, 5
    radius = (sprite\getBounds 0, 0).radius
    direction = Vector x - @player.position.x, y - @player.position.y, true
    direction\rotate (-math.pi / 2)
    num_steps = 20
    rotation_step = math.pi / num_steps
    offset = Vector -Screen_Size.half_width, -Screen_Size.half_height
    timer = Timer use_time / num_steps, @, (() =>
      player_out = @start_rotation\multiply (radius * 7)
      sprite\setRotation (player_out\getAngle! + (math.pi / 2))
      particle = EnemyPoisonParticle @parent.player.position.x, @parent.player.position.y, sprite, 255, 0, 20 * (use_time / num_steps)
      particle.position\add offset
      particle.position\add (@start_rotation\multiply (radius * 4))
      particle.damage = @parent.damage
      Driver\addObject particle, EntityTypes.particle
      @start_rotation\rotate rotation_step
      @activations += 1
      if @activations >= num_steps
        @done = true
        @parent.used = false
    )
    timer.activations = 0
    timer.start_rotation = direction
