export class WorldHandler
  new: =>
    @valueRegex = "=\"([%w%d%./_]+)\""
    @tiles = @loadTiles!
    @map = @loadMap!

    wallColor = Color 127, 127, 0
    wtop = Wall -64, -64, 3200 + 128, 64, wallColor
    wbot = Wall -64, 3200, 3200 + 128, 64, wallColor
    wlft = Wall -64, -64, 64, 3200 + 128, wallColor
    wrgt = Wall 3200, -64, 64, 3200 + 128, wallColor
    Driver\addObject wtop, EntityTypes.wall
    Driver\addObject wbot, EntityTypes.wall
    Driver\addObject wlft, EntityTypes.wall
    Driver\addObject wrgt, EntityTypes.wall

    -- Combine horizontally
    for rowIdx, row in pairs @map
      colIdx = 1
      while colIdx <= #row
        val = @map[rowIdx][colIdx]
        if val == @wallId
          startCol = colIdx
          while @map[rowIdx][colIdx] == @wallId
            @map[rowIdx][colIdx] = 0
            colIdx += 1
          delta = colIdx - startCol
          if delta == 0
            @map[rowIdx][colIdx] = @wallId
          elseif delta == 1
            @map[rowIdx][colIdx - 1] = @wallId
          else
            x = (startCol - 1) * 32
            y = (rowIdx - 1) * 32
            w = Wall x, y, delta * 32, 32, wallColor
            Driver\addObject w, EntityTypes.wall
        else
          colIdx += 1

    -- Combine vertically
    for colIdx, col in pairs @map
      rowIdx = 1
      while rowIdx <= #col
        val = @map[rowIdx][colIdx]
        if val == @wallId
          startRow = rowIdx
          while @map[rowIdx][colIdx] == @wallId
            @map[rowIdx][colIdx] = 0
            rowIdx += 1
          delta = rowIdx - startRow
          if delta == 0
            @map[rowIdx][colIdx] = @wallId
          elseif delta == 1
            @map[rowIdx - 1][colIdx] = @wallId
          else
            x = (colIdx - 1) * 32
            y = (startRow - 1) * 32
            w = Wall x, y, 32, delta * 32, wallColor
            Driver\addObject w, EntityTypes.wall
        else
          rowIdx += 1

    -- Create remaining
    for rowIdx, row in pairs @map
      for colIdx, val in pairs row
        if val == @wallId
          x = (colIdx - 1) * 32
          y = (rowIdx - 1) * 32
          w = Wall x, y, 32, 32, wallColor
          Driver\addObject w, EntityTypes.wall
          @map[rowIdx][colIdx] = 0

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
      if path == "map/tiles/wall.tga"
        @wallId = id + 1
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
        if val != 0
          x = ((colIdx - 1) * 32) + Screen_Size.half_width
          y = ((rowIdx - 1) * 32) + Screen_Size.half_height
          if Camera\isOnScreen x, y, 32, 32
            @tiles[val]\draw x, y
            if DEBUGGING
              love.graphics.setColor 0, 0, 1
              love.graphics.rectangle "line", x - 16, y - 16, 32, 32
