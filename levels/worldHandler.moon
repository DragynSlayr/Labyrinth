export class WorldHandler
  new: =>
    @valueRegex = "=\"([%w%d%./_]+)\""
    @idx = 1

    @loadTiles!
    @loadMaps!

    -- @createWalls!

    -- @goto 2

  goto: (idx) =>
    @idx = idx
    QuestHandler\goto idx
    TimerHandler\goto idx
    WallHandler\goto idx
    BackgroundHandler\goto idx
    ParticleHandler\goto idx
    BulletHandler\goto idx
    BossHandler\goto idx
    EnemyHandler\goto idx
    NPCHandler\goto idx

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
    @tiles = {}
    for i = 1, numTiles
      id = tonumber (string.gmatch lines!, @valueRegex)!
      tileInfo = string.gmatch lines!, @valueRegex
      width = tonumber tileInfo!
      height = tonumber tileInfo!
      path = "map/" .. tileInfo!
      if path == "map/tiles/wall.tga"
        @wallId = id + 1
      @tiles[id + 1] = Sprite path, height, width
      lines!

  loadMaps: =>
    @map = {}
    paths = {"town.tmx", "area1.tmx"}
    for k, path in pairs paths
      path = "assets/sprites/map/" .. path
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
      @map[k] = {}
      for i = 1, numRows
        row = lines!
        line = {}
        for val in string.gmatch row, "(%d+)"
          table.insert line, (tonumber val)
        table.insert @map[k], line

  createWalls: =>
    oldIdx = @idx
    wallColor = Color 127, 127, 0

    for k, map in pairs @map
      @goto k

      -- Combine horizontally
      for rowIdx, row in pairs map
        colIdx = 1
        while colIdx <= #row
          val = map[rowIdx][colIdx]
          if val == @wallId
            startCol = colIdx
            while map[rowIdx][colIdx] == @wallId
              map[rowIdx][colIdx] = 0
              colIdx += 1
            delta = colIdx - startCol
            if delta == 0
              map[rowIdx][colIdx] = @wallId
            elseif delta == 1
              map[rowIdx][colIdx - 1] = @wallId
            else
              x = (startCol - 1) * 32
              y = (rowIdx - 1) * 32
              w = Wall x, y, delta * 32, 32, wallColor
          else
            colIdx += 1

      -- Combine vertically
      for colIdx, col in pairs map
        rowIdx = 1
        while rowIdx <= #col
          val = map[rowIdx][colIdx]
          if val == @wallId
            startRow = rowIdx
            while map[rowIdx][colIdx] == @wallId
              map[rowIdx][colIdx] = 0
              rowIdx += 1
            delta = rowIdx - startRow
            if delta == 0
              map[rowIdx][colIdx] = @wallId
            elseif delta == 1
              map[rowIdx - 1][colIdx] = @wallId
            else
              x = (colIdx - 1) * 32
              y = (startRow - 1) * 32
              w = Wall x, y, 32, delta * 32, wallColor
          else
            rowIdx += 1

      -- Create remaining
      for rowIdx, row in pairs map
        for colIdx, val in pairs row
          if val == @wallId
            x = (colIdx - 1) * 32
            y = (rowIdx - 1) * 32
            w = Wall x, y, 32, 32, wallColor
            map[rowIdx][colIdx] = 0

    @goto oldIdx

  entityKilled: (entity) =>
    return

  update: (dt) =>
    for k, v in pairs @tiles
      v\update dt

  draw: =>
    for rowIdx, row in pairs @map[@idx]
      for colIdx, val in pairs row
        if val != 0
          x = ((colIdx - 1) * 32) + Screen_Size.half_width
          y = ((rowIdx - 1) * 32) + Screen_Size.half_height
          if Camera\isOnScreen x, y, 32, 32
            @tiles[val]\draw x, y
            -- if DEBUGGING
            --   love.graphics.setColor 0, 0, 1
            --   love.graphics.rectangle "line", x - 16, y - 16, 32, 32
