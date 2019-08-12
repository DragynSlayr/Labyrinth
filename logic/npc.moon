export class NPC extends GameObject
  new: (x, y, text = {}) =>
    sprite = Sprite "npc/npc.tga", 48, 26, 1, 2.5
    super x, y, sprite

    @text = text
    @draw_health = false
    @clicked = false

    NPCHandler\add @

  mousepressed: (x, y, button, isTouch) =>
    @clicked = @isHovering x, y
    return @clicked

  mousereleased: (x, y, button, isTouch) =>
    was_clicked = false
    if (@isHovering x, y) and @clicked
      if #@text > 0
        Driver.dialog\updateBox @text
      was_clicked = true
    @clicked = false
    return was_clicked

  isHovering: (x, y) =>
    x += Camera.position.x - Screen_Size.half_width
    y += Camera.position.y - Screen_Size.half_height
    width = @sprite.scaled_width / 2
    height = @sprite.scaled_height / 2
    xOn = x >= @position.x - width and x <= @position.x + width
    yOn = y >= @position.y - height and y <= @position.y + height
    return xOn and yOn
