export class WorldHandler
  new: =>
    @valueRegex = "=\"([%w%d%./_]+)\""
    @tiles = @loadTiles!
    @map = @loadMap!

  loadMap: =>
    path = "assets/sprites/map/town.tmx"
    if love.filesystem.getInfo (PATH_PREFIX .. path)
      path = PATH_PREFIX .. path
    lines = love.filesystem.lines path
    lines!
    info = lines!
    values = {}
    for x in string.gmatch info, @valueRegex
      table.insert values, x
    numRows = tonumber values[4]
    for i = 1, 3
      lines!
    map = {}
    for i = 1, numRows
      row = lines!
      line = {}
      for val in string.gmatch row, "(%d+)"
        table.insert line, (tonumber val)
      table.insert map, line
    return map

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
    for k, v in pairs @tiles
      v\update dt

  draw: =>
    for rowIdx, row in pairs @map
      for colIdx, val in pairs row
        x = (colIdx - 51) * 32
        y = (rowIdx - 51) * 32
        if @isOnScreen x, y
          @tiles[val]\draw x, y

  isOnScreen: (x, y) =>
    xOn = x >= Camera.position.x - 32 and x - 32 <= Camera.position.x + Screen_Size.width
    yOn = y >= Camera.position.y - 32 and y - 32 <= Camera.position.y + Screen_Size.height
    return xOn and yOn
