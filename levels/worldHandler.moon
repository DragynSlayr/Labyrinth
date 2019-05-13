export class WorldHandler
  new: =>
    --@bg = Sprite "level/mainTown.tga", 1080, 1920, 1, 4
    @position = Vector!
    @valueRegex = "=\"([%w%d%./_]+)\""
    @tiles = @loadTiles!

  loadTiles: =>
    path = "assets/sprites/map/tiles.tsx"
    if love.filesystem.getInfo (PATH_PREFIX .. path)
      path = PATH_PREFIX .. path
    lines = love.filesystem.lines path
    lines!
    info = lines!
    values = {}
    for x in string.gmatch info, @valueRegex
      table.insert values, x
    numTiles = tonumber values[6]
    lines!
    tiles = {}
    for i = 1, numTiles
      id = tonumber (string.gmatch lines!, @valueRegex)!
      tileInfo = string.gmatch lines!, @valueRegex
      width = tonumber tileInfo!
      height = tonumber tileInfo!
      path = "map/" .. tileInfo!
      tiles[id + 1] = Sprite path, height, width
      lines!
    return tiles

  entityKilled: (entity) =>
    return

  update: (dt) =>
    return

  draw: =>
    love.graphics.push "all"
    --@bg\draw @position.x, @position.y
    love.graphics.pop!
