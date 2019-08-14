export class Handler
  new: =>
    @objects = {}

  add: (object) =>
    table.insert @objects, object

  remove: (object, player_kill) =>
    for k, v in pairs @objects
      if v == object
        if player_kill
          for k, player in Driver.objects[EntityTypes.player]
            player\onKill v
          v\kill!
          World\entityKilled v
        table.remove @objects, k
        return

  clear: =>
    @objects = {}

  mousepressed: (x, y, button, isTouch) =>
    clicked = false
    for k, v in pairs @objects
      if (v\mousepressed x, y, button, isTouch)
        clicked = true
    return clicked

  mousereleased: (x, y, button, isTouch) =>
    clicked = false
    for k, v in pairs @objects
      if (v\mousereleased x, y, button, isTouch)
        clicked = true
    return clicked

  update: (dt) =>
    for k, v in pairs @objects
      v\update dt
    for k, v in pairs @objects
      if v.health <= 0 or not v.alive
        @remove v

  draw: =>
    for k, v in pairs @objects
      v\draw!
