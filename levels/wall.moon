export class Wall extends GameObject
  new: (x, y, width, height, color) =>
    sprite = Sprite "map/block.tga", 32, 32, 1, 1
    super x, y, sprite

    @sprite\setScale width / 32, height / 32
    @sprite\setColor {color\get!}
    @damage = 0
    @solid = true
    @draw_health = false
    @colliders = {EntityTypes.player, EntityTypes.bullet}
    @position\add Vector @sprite.scaled_width / 2, @sprite.scaled_height / 2
    @position\add Vector -16, -16

  getHitBox: =>
    return Rectangle @position.x - @sprite.scaled_width / 2, @position.y - @sprite.scaled_height / 2, @sprite.scaled_width, @sprite.scaled_height

  draw: =>
    @sprite\draw @position.x, @position.y

    if DEBUGGING
      @getHitBox!\draw!
