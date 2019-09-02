class Door extends BackgroundObject
  new: (x, y, targetIdx, targetX, targetY) =>
    sprite = Sprite "background/door.tga", 32, 32, 1, 2
    x = (x * 32) + 16
    y = (y * 32) + 16
    super x, y, sprite

    @targetIdx = targetIdx
    @target = Vector (targetX * 32) + 16 + Screen_Size.half_width, (targetY * 32) + 16 + Screen_Size.half_height

  update: (dt) =>
    if MainPlayer.canTeleport and @getHitBox!\contains MainPlayer\getHitBox!
      MainPlayer.canTeleport = false
      World\goto @targetIdx
      MainPlayer.position = @target\getCopy!
      Timer 2, @, (() =>
        MainPlayer.canTeleport = true
      ), false

  draw: =>
    if MainPlayer.canTeleport
      super!
    else if @isOnScreen!
      old_color = @sprite.color
      @sprite.color = {175, 175, 175, 150}
      @sprite\draw @position.x, @position.y
      @sprite.color = old_color

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
