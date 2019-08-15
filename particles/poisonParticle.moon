export class PoisonParticle extends Particle
  new: (x, y, sprite, alpha_start, alpha_end, life_time) =>
    super x, y, sprite, alpha_start, alpha_end, life_time
    @damage = 0.01

  update: (dt) =>
    super dt
    if @alive
      other = MainPlayer\getHitBox!
      this = @getHitBox!
      if other\contains this
        MainPlayer\onCollide @
