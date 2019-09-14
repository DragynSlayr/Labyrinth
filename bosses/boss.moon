export class Boss extends GameObject
  new: (x, y, sprite) =>
    super x, y, sprite

    @bossType = nil
    @contact_damage = true
    @solid = true
