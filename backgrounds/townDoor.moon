class Door extends BackgroundObject
  new: (x, y, targetIdx, targetX, targetY) =>
    sprite =
    super x, y, sprite


export class TownDoor
  new: (door1, door2) =>
    x1, y1, i1 = unpack door1
    x2, y2, i2 = unpack door2

    oldIdx = World.idx

    World\goto i1
    Door x1, y1, i2, x2, y2

    World\goto i2
    Door x2, y2, i1, x1, y1

    World\goto oldIdx
