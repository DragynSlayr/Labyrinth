export class MeleeSword extends MeleeWeapon
  new: (player) =>
    sprite = Sprite "unused/wormhole.tga", 40, 40, 1, 1
    use_time = 3
    action = (x, y, button, isTouch) =>
      @used = true
      sprite = Sprite "item/trailActive.tga", 32, 32, 1, 1.75
      radius = (sprite\getBounds 0, 0).radius
      direction = Vector x - @player.position.x, y - @player.position.y, true
      for i = 1, 6
        particle = EnemyPoisonParticle @player.position.x, @player.position.y, sprite, 127, 0, use_time
        particle.position\add (Vector -Screen_Size.half_width, -Screen_Size.half_height)
        particle.position\add (direction\multiply (i * radius * 1.5))
        particle.damage = @damage
        Driver\addObject particle, EntityTypes.particle
      Timer use_time, @, (() =>
        @parent.used = false
      ), false
    super player, sprite, action, use_time
    @used = false
    @damage = 0.1

  draw: =>
    if @used
      @sprite\draw @player.position.x, @player.position.y
