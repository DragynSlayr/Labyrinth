export class Icon extends UIElement
  new: (x, y, sprite) =>
    super x, y
    @sprite = sprite

  update: (dt) =>
    @sprite\update dt

  draw: =>
    Camera\unset!
    @sprite\draw @x, @y
    Camera\set!
