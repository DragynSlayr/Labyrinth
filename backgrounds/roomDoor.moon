export class RoomDoor extends BackgroundObject
  new: (x, y, target) =>
    sprite = Sprite "background/roomDoor.tga", 32, 32, 1, 2
    super x, y, sprite
    @target = target
    @active = false
    @exitLocation = nil

  update: (dt) =>
    super dt
    if @active
      target = MainPlayer\getHitBox!
      door = @getHitBox!
      if door\contains target
        x, y = unpack @exitLocation
        MainPlayer.position = Vector x, y
        Levels\moveToRoom @target

  getHitBox: =>
    width = @sprite.scaled_width
    height = @sprite.scaled_height
    rect = Rectangle @position.x - (width / 2), @position.y - (height / 2), width, height
    return rect

  open: =>
    @active = true

  close: =>
    @active = false

  draw: =>
    if not @active return
    super!
