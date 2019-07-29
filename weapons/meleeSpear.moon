export class MeleeSpear extends Weapon
  new: (player) =>
    sprite = Sprite "weapon/spearMini.tga", 51, 51
    super player, sprite

  calcDamage: =>
    return @player.stats.dexterity / 100.0

  action: (x, y, button, isTouch) =>
    if button != 1 return
    @used = true
    use_time = 0.50
    sprite = Sprite "weapon/spear.tga", 64, 30, 1, 2.5
    radius = (sprite\getBounds 0, 0).radius
    direction = Vector x - @player.position.x, y - @player.position.y, true
    num_steps = 20
    offset = Vector -Screen_Size.half_width, -Screen_Size.half_height
    timer = Timer use_time / num_steps, @, (() =>
      player_out = @start_direction\multiply (radius * 7)
      sprite\setRotation (player_out\getAngle! + (math.pi / 2))
      particle = EnemyPoisonParticle @parent.player.position.x, @parent.player.position.y, sprite, 255, 0, 15 * (use_time / num_steps)
      particle.position\add offset
      protrusion = (7.5 * (math.sin (math.pi * (@activations / num_steps)))) + 1.0
      particle.position\add (@start_direction\multiply (radius * protrusion))
      particle.damage = @parent.damage
      Driver\addObject particle, EntityTypes.particle
      @activations += 1
      if @activations >= num_steps
        @done = true
        @parent.used = false
    )
    timer.activations = 0
    timer.start_direction = direction
