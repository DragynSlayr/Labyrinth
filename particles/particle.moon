export class Particle extends GameObject
  new: (x, y, sprite, alpha_start = 255, alpha_end = 0, life_time = 1) =>
    super x, y, sprite\getCopy!
    @alpha = alpha_start
    @alpha_start = alpha_start
    @alpha_end = alpha_end
    @draw_health = false
    @id = EntityTypes.particle
    @sprite.color[4] = @alpha
    @solid = false
    @count = 0
    @life_time = life_time

    @setShader love.graphics.newShader "shaders/normal.fs"

  setShader: (shader, apply = false) =>
    @sprite\setShader shader
    @block_shader = apply
    @sprite.should_shade = @block_shader

  update: (dt) =>
    if @speed\getLength! > 0
      @position\add @speed\multiply dt
    @sprite\update dt
    @count += dt
    if @count >= @life_time
      @health = 0
    else
      @alpha = @alpha_start + ((@alpha_end - @alpha_start) * (@count / @life_time))
      alpha = math.floor @alpha
      @sprite.color[4] = clamp alpha, 0, 255
