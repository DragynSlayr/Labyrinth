class NPCPathNode
  new: (speed, time) =>
    @speed = speed
    @max_time = time

    @restart!

  restart: =>
    @elapsed = 0
    @done = false

  update: (dt) =>
    @elapsed += dt
    if @elapsed >= @max_time
      @done = true

class NPCPath
  new: (npc) =>
    @npc = npc
    @objects = {}
    @idx = 1

  clear: =>
    @objects = {}

  addNode: (x, y, time) =>
    node = NPCPathNode x, y, time
    table.insert @objects, node

  update: (dt) =>
    node = @objects[@idx]
    node\update dt

    if node.done
      @idx += 1
      if @idx > #@objects
        @idx = 1
      node\restart!
    else
      @npc.speed = node.speed

export class NPC extends GameObject
  new: (x, y, name = "", text = {}) =>
    sprite = Sprite "npc/npc.tga", 48, 26, 1, 2
    super x, y, sprite

    @name = name
    @text = text
    @draw_health = false
    @clicked = false

    @path = NPCPath @

    NPCHandler\add @

  setPath: (path) =>
    @path\clear!
    for k, v in pairs path
      @path\addNode v[1], v[2]

  mousepressed: (x, y, button, isTouch) =>
    @clicked = @isHovering x, y
    return @clicked

  mousereleased: (x, y, button, isTouch) =>
    was_clicked = false
    if (@isHovering x, y) and @clicked
      if #@text > 0
        Driver.dialog\updateBox @text, @name
      was_clicked = true
    @clicked = false
    return was_clicked

  update: (dt) =>
    @path\update dt
    super dt

  draw: =>
    super!
    width = love.graphics.getFont!\getWidth @name
    height = love.graphics.getFont!\getHeight!
    x = @position.x - (width / 2)
    y = @position.y - (@sprite.scaled_height / 2) - 35

    setColor 0, 0, 0, 200
    love.graphics.rectangle "fill", x - 6, y - 2, width + 12, height + 4, 3, 3
    love.graphics.setLineWidth 2
    setColor 150, 150, 150, 255
    love.graphics.rectangle "line", x - 6, y - 2, width + 12, height + 4, 3, 3
    love.graphics.setLineWidth 1
    setColor 255, 255, 255, 255
    love.graphics.printf @name, x, y, width, "center"

  isHovering: (x, y) =>
    x += Camera.position.x - Screen_Size.half_width
    y += Camera.position.y - Screen_Size.half_height
    width = @sprite.scaled_width / 2
    height = @sprite.scaled_height / 2
    xOn = x >= @position.x - width and x <= @position.x + width
    yOn = y >= @position.y - height and y <= @position.y + height
    return xOn and yOn
