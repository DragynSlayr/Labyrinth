export class WorldHandler
  new: =>
    @valueRegex = "=\"([%w%d%./_]+)\""
    @tiles = @loadTiles!
    @map = @loadMap!
    --x = (50 * -32) + Screen_Size.half_width -- -640
    --y = (75 * -32) + Screen_Size.half_height -- -1860
    @position = Vector!-- x, y
    --print (x .. ", " .. y)
    --@bounds = {-2180, 940, 0, 0}

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
    return
    -- for k, v in pairs @tiles
    --   v\update dt
    --@position.x = clamp @position.x, 0, 100 * 32
      --@position.y = clamp @position.y, Screen_Size.border[2] + radius, (Screen_Size.border[4] + Screen_Size.border[2]) - radius

  draw: =>
    love.graphics.push "all"
    love.graphics.translate -@position.x, -@position.y
    for rowIdx, row in pairs @map
      for colIdx, val in pairs row
        -- x = @position.x + ((colIdx - 1) * 32)
        -- y = @position.y + ((rowIdx - 1) * 32)
        x = (colIdx - 51) * 32
        y = (rowIdx - 51) * 32
        -- x = (colIdx - 51) * 32
        -- y = (rowIdx - 51) * 32
        --if @isOnScreen x, y
        @tiles[val]\draw x, y
    love.graphics.pop!

  isOnScreen: (x, y) =>
    xOn = x >= -64 and x - 32 <= Screen_Size.width
    yOn = y >= -64 and y - 32 <= Screen_Size.height
    return xOn and yOn
