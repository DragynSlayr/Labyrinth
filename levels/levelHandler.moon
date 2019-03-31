export class LevelHandler
  new: =>
    @level = nil
    @num = 0

  nextLevel: =>
    @num += 1
    @level = Level!
    @level\generate!

  moveToRoom: (room) =>
    @level\moveToRoom room
    room\closeDoors!
    room.timer = 0

  entityKilled: (entity) =>
    if not @level return
    @level\entityKilled entity

  update: (dt) =>
    if not @level return
    @level\update dt

  draw: =>
    if not @level return
    @level\draw!
