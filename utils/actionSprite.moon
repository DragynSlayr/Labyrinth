export class ActionSprite extends Sprite
  new: (name, height, width, delay, scale, parent, action) =>
    super name, height, width, delay, scale
    @parent = parent
    @action = action

  finish: =>
    @parent.sprite = @parent.normal_sprite
    @action!

  update: (dt) =>
    start = @current_frame
    super dt
    if start > @current_frame
      @finish!
