export class PopupText extends Text
  new: (x, y, text, lifetime, font) =>
    super x, y, text, font
    @lifetime = lifetime
    @elapsed = 0
    @active = true

  update: (dt) =>
    if not @active return
    @elapsed += dt
    if @elapsed > @lifetime
      @active = false

  draw: =>
    if not @active return
    alpha = math.sin (math.pi * (@elapsed / @lifetime))
    @color[4] = alpha * 255
    super!
