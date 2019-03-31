export class RoomDoor extends BackgroundObject
  new: (x, y, target) =>
    sprite = Sprite "background/healingField.tga", 32, 32, 2, 4
    super x, y, sprite
    @target = target
    @active = false

  update: (dt) =>
    super dt
    if not @active return
    for k, p in pairs Driver.objects[EntityTypes.player]
      target = p\getHitBox!
      door = @getHitBox!
      if target\contains door
        Levels\moveToRoom @target

  open: =>
    @active = true

  close: =>
    @active = false

  draw: =>
    if not @active return
    super!
