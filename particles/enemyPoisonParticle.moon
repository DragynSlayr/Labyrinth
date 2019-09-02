export class EnemyPoisonParticle extends Particle
  new: (x, y, sprite, alpha_start, alpha_end, life_time) =>
    super x, y, sprite, alpha_start, alpha_end, life_time
    @damage = 0.01

  update: (dt) =>
    super dt
    if @alive
      filters = {EnemyHandler, BossHandler}
      for k2, filter in pairs filters
        for k, v in pairs filter.objects[World.idx]
          other = v\getHitBox!
          this = @getHitBox!
          if other\contains this
            v\onCollide @
