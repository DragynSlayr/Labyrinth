export class Room
  new: =>
    @adjacent = {nil, nil, nil, nil}
    @numAdjacent = 0
    @doorLocations = {
      {Screen_Size.half_width, 0},
      {Screen_Size.width, Screen_Size.half_height},
      {Screen_Size.half_width, Screen_Size.height},
      {0, Screen_Size.half_height}
    }
    @num = 0
    @doors = {}
    @x = 0
    @y = 0
    @doorsOpen = false
    @timer = 0

  link: =>
    for k, nbr in pairs @adjacent
      if nbr
        x, y = unpack @doorLocations[k]
        door = RoomDoor x, y, nbr
        door.active = false
        idx = k + 2
        if k >= 3
          idx = k - 2
        door.exitLocation = @doorLocations[idx]
        table.insert @doors, door
        @countAdjacent!
    @closeDoors!

  countAdjacent: =>
    @numAdjacent = 0
    for k, r in pairs @adjacent
      if r
        @numAdjacent += 1

  openDoors: =>
    for k, d in pairs @doors
      d\open!
    @doorsOpen = true

  closeDoors: =>
    for k, d in pairs @doors
      d\close!
    @doorsOpen = false

  entityKilled: (entity) =>
    return -- handle

  update: (dt) =>
    if not @doorsOpen
      @timer += dt
      if @timer >= 2
        @openDoors!

  draw: =>
    return -- draw background stuff maybe
