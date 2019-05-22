export class CameraHandler
  new: =>
    @position = Vector -Screen_Size.half_width, (Screen_Size.height * 0.15)
    @scale = Vector 1, 1
    @rotation = 0
    @isSet = false

  scale: (zx, zy) =>
    @scale = Vector zx, zy

  rotate: (newRotation) =>
    @rotation = newRotation

  moveTo: (newPos) =>
    @position = newPos

  shift: (dx, dy) =>
    @position\add (Vector dx, dy)

  set: =>
    if not @isSet
      love.graphics.push!
      love.graphics.rotate -@rotation
      love.graphics.scale (1 / @scale.x), (1 / @scale.y)
      love.graphics.translate -@position.x, -@position.y
      @isSet = true

  unset: =>
    if @isSet
      love.graphics.pop!
      @isSet = false
