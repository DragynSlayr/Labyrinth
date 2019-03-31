export class EnemyPoisonParticle extends Particle
  new: (x, y, sprite, alpha_start, alpha_end, life_time) =>
    super x, y, sprite, alpha_start, alpha_end, life_time
    @damage = 0.01

  update: (dt) =>
    super dt
    if @alive
      for k, v in pairs Driver.objects[EntityTypes.enemy]
        other = v\getHitBox!
        this = @getHitBox!
        if other\contains this
          v\onCollide @
      for k, v in pairs Driver.objects[EntityTypes.boss]
        other = v\getHitBox!
        this = @getHitBox!
        if other\contains this
          v\onCollide @
