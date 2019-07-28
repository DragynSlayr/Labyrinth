export class CameraHandler
  new: =>
    @position = Vector!
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
      love.graphics.translate -@position.x + Screen_Size.half_width, -@position.y + Screen_Size.half_height
      @isSet = true

  unset: =>
    if @isSet
      love.graphics.pop!
      @isSet = false

  isOnScreen: (x, y, width, height) =>
    xOn = x >= @position.x - width - Screen_Size.half_width and x - width <= @position.x + Screen_Size.half_width
    yOn = y >= @position.y - height - Screen_Size.half_height and y - height <= @position.y + Screen_Size.half_height
    return xOn and yOn
