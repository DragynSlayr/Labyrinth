export class Wall extends GameObject
  new: (x, y, width, height, color) =>
    sprite = Sprite "maps/block.tga", 32, 32, 1, 1
    super x, y, sprite

    @sprite.color = color\get!
    @sprite\setScale width / 32, height / 32
    @width = width
    @height = height
    @color = color
    @id = EntityTypes.wall
    @damage = 0

  getHitBox: =>
    return Rectangle @position.x, @position.y, @width, @height

  draw: =>
    love.graphics.push "all"

    if DEBUGGING
      setColor 0, 255, 0, 255
      @getHitBox!\draw!

    love.graphics.setShader Driver.shader

    setColor @color\get!
    love.graphics.rectangle "fill", @position.x, @position.y, @width, @height

    love.graphics.setShader!
    love.graphics.pop!
