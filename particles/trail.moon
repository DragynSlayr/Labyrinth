export class ParticleTrail extends GameObject
  new: (x, y, sprite, parent) =>
    super x, y, sprite\getCopy!
    @objects = {}
    @parent = parent
    @solid = false
    @last_position = Vector @parent.position\getComponents!
    @position = @last_position
    @life_time = 1
    @average_size = (@sprite.scaled_width + @sprite.scaled_height) / 8
    @particle_type = ParticleTypes.normal
    @damage = 0.01

    ParticleHandler\add @

  kill: =>
    super!
    @objects = {}

  update: (dt) =>
    if @speed\getLength! > 0
      @position\add @speed\multiply dt
    else
      @position = @parent.position
    @sprite.rotation = @parent.sprite.rotation
    for k, v in pairs @objects
      v\update dt
      if v.health <= 0
        table.remove @objects, k
    change = Vector @last_position.x - @position.x, @last_position.y - @position.y
    if change\getLength! >= @average_size
      @last_position = Vector @parent.position\getComponents!
      x = @position.x - Screen_Size.half_width
      y = @position.y - Screen_Size.half_height
      particle = switch @particle_type
        when ParticleTypes.normal
          Particle x, y, @sprite, 255, 0, @life_time
        when ParticleTypes.poison
          PoisonParticle x, y, @sprite, 255, 0, @life_time
        when ParticleTypes.enemy_poison
          EnemyPoisonParticle x, y, @sprite, 255, 0, @life_time
      particle.damage = @damage
      table.insert @objects, particle

  draw: =>
    for k, v in pairs @objects
      v\draw!
