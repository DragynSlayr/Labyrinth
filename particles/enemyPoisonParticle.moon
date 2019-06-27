export class EnemyPoisonParticle extends Particle
  new: (x, y, sprite, alpha_start, alpha_end, life_time) =>
    super x, y, sprite, alpha_start, alpha_end, life_time
    @damage = 0.01

  update: (dt) =>
    super dt
    if @alive
      filters = {EntityTypes.enemy, EntityTypes.boss}
      for k2, filter in pairs filters
        for k, v in pairs Driver.objects[filter]
          other = v\getHitBox!
          this = @getHitBox!
          if other\contains this
            v\onCollide @
