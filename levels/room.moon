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

  link: =>
    for k, nbr in pairs @adjacent
      if nbr
        x, y = unpack @doorLocations[k]
        door = RoomDoor x, y, nbr
        door.active = false
        table.insert @doors, door
        Driver\addObject door, EntityTypes.background
        @numAdjacent += 1
    @closeDoors!

  openDoors: =>
    for k, d in pairs @doors
      d\open!

  closeDoors: =>
    for k, d in pairs @doors
      d\close!

  entityKilled: (entity) =>
    return -- handle

  update: (dt) =>
    return -- handle changes

  draw: =>
    return -- draw background stuff maybe
