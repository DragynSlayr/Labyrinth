export class WorldHandler
  new: =>
    @bg = Sprite "level/mainTown.tga", 1080, 1920, 1, 4
    @position = Vector!

  entityKilled: (entity) =>
    return

  update: (dt) =>
    return

  draw: =>
    love.graphics.push "all"
    love.graphics.translate @position\getComponents!
    @bg\draw @bg.width / 2, @bg.height / 2
    love.graphics.pop!
