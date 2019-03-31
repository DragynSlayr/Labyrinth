class RoomList
  getOpposite: (num) ->
    switch num
      when 1 return 3
      when 2 return 4
      when 3 return 1
      when 4 return 2

  new: =>
    @start = Room!
    @count = 0
    @rooms = {@start}
    @min_x = 0
    @max_x = 0
    @min_y = 0
    @max_y = 0

  spotAvailable: (x, y) =>
    for k, room in pairs @rooms
      if room.x == x and room.y == y
        return false
    return true

  fixBounds: (x, y) =>
    if x < @min_x
      @min_x = x
    if x > @max_x
      @max_x = x
    if y < @min_y
      @min_y = y
    if y > @max_y
      @max_y = y

  addRoom: (room) =>
    num = math.random 4
    iters = 0
    while room.adjacent[num]
      num = math.random 4
      iters += 1
      if iters == 4
        return false
    nr = Room!
    nr.x = room.x
    if num == 2
      nr.x += 1
    else if num == 4
      nr.x -= 1
    nr.y = room.y
    if num == 1
      nr.y += 1
    else if num == 3
      nr.y -= 1
    @fixBounds nr.x, nr.y
    if @spotAvailable nr.x, nr.y
      @count += 1
      nr.num = @count
      room.adjacent[num] = nr
      nr.adjacent[RoomList.getOpposite num] = room
      table.insert @rooms, nr
      return true
    else
      return false

  checkAdjacency: (room1, room2) =>
    dx = room1.x - room2.x
    dy = room1.y - room2.y
    if dx == 1 and dy == 0
      room1.adjacent[4] = room2
      room2.adjacent[2] = room1
    if dx == -1 and dy == 0
      room1.adjacent[2] = room2
      room2.adjacent[4] = room1
    if dy == 1 and dx == 0
      room1.adjacent[3] = room2
      room2.adjacent[1] = room1
    if dy == -1 and dx == 0
      room1.adjacent[1] = room2
      room2.adjacent[3] = room1

  linkRooms: =>
    for k1, room1 in pairs @rooms
      for k2, room2 in pairs @rooms
        if k1 ~= k2
          @checkAdjacency room1, room2
    for k, room in pairs @rooms
      room\link!

  drawMap: (current_room) =>
    x_span = @max_x - @min_x
    y_span = @max_y - @min_y
    start_x = Screen_Size.width - 270
    start_y = 325
    cell_width = 250 / (x_span + 1)
    cell_height = 250 / (y_span + 1)
    love.graphics.setColor 0, 0, 0, 0.5
    love.graphics.rectangle "fill", start_x - 10, 70, 265, 265
    love.graphics.translate start_x, start_y
    love.graphics.scale 1, -1
    for i, room in pairs @rooms
      x = (room.x - @min_x) * cell_width
      y = (room.y - @min_y) * cell_height
      if room == current_room
        love.graphics.setColor 0.7, 0.7, 0.7, 0.7
      else
        love.graphics.setColor 0.5, 0.5, 0.5, 0.7
      love.graphics.rectangle "fill", x, y, cell_width * 0.85, cell_height * 0.85

export class Level
  new: =>
    @rooms = RoomList!
    @current_room = @rooms.start
    @min_rooms = 20
    @num_rooms = 1

  generate: =>
    count = 1
    while count < @min_rooms
      num = math.random #@rooms.rooms
      room = @rooms.rooms[num]
      if room.numAdjacent ~= 4
        if @rooms\addRoom room
          count += 1
          print ("Room " .. count .. " generated")
    @num_rooms = count
    @rooms\linkRooms!
    @current_room\openDoors!

  entityKilled: (entity) =>
    return -- send to room

  update: (dt) =>
    @current_room\update dt

  moveToRoom: (room) =>
    @current_room\closeDoors!
    @current_room = room
    @current_room\openDoors!

  draw: =>
    love.graphics.push "all"
    message = "Room: " .. @current_room.num .. " / " .. @num_rooms .. " (" .. @current_room.x .. ", " .. @current_room.y .. ")"
    message ..= " X: [" .. @rooms.min_x .. ", " .. @rooms.max_x .. "]"
    message ..= " Y: [" .. @rooms.min_y .. ", " .. @rooms.max_y .. "]"
    Renderer\drawAlignedMessage message, Screen_Size.half_height
    @rooms\drawMap @current_room
    love.graphics.pop!
