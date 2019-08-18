export class BackgroundObject extends GameObject
  new: (x, y, sprite) =>
    super x, y, sprite
    @draw_health = false

    BackgroundHandler\add @
