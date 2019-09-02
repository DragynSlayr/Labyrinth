export class Handler
  new: =>
    @objects = {}

  goto: (idx) =>
    if not @objects[idx]
      @objects[idx] = {}

  add: (object) =>
    table.insert @objects[World.idx], object

  remove: (object, player_kill = true) =>
    for k, v in pairs @objects[World.idx]
      if v == object
        if player_kill
          MainPlayer\onKill v
        if v.kill
          v\kill!
        World\entityKilled v
        table.remove @objects[World.idx], k
        return

  clear: =>
    @objects[World.idx] = {}

  mousepressed: (x, y, button, isTouch) =>
    clicked = false
    for k, v in pairs @objects[World.idx]
      if (v\mousepressed x, y, button, isTouch)
        clicked = true
    return clicked

  mousereleased: (x, y, button, isTouch) =>
    clicked = false
    for k, v in pairs @objects[World.idx]
      if (v\mousereleased x, y, button, isTouch)
        clicked = true
    return clicked

  update: (dt) =>
    for k, v in pairs @objects[World.idx]
      v\update dt
    for k, v in pairs @objects[World.idx]
      if v.done != nil
        if v.done
          @remove v
      else if v.health <= 0 or not v.alive
        @remove v

  draw: =>
    for k, v in pairs @objects[World.idx]
      v\draw!
