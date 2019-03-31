export class TestWave extends Wave
  new: (parent) =>
    super parent

  start: =>
    @enemy = StrongEnemy 100, 100
    Driver\addObject @enemy, EntityTypes.enemy
    --for i = 1, 2
    --  x = math.random Screen_Size.border[1], Screen_Size.border[3] + Screen_Size.border[1]
    --  y = math.random Screen_Size.border[2], Screen_Size.border[4] + Screen_Size.border[2]
    --  Driver\addObject (CloudEnemy x, y), EntityTypes.enemy

  update: (dt) =>
    if @enemy
      @enemy.speed_multiplier = 0
      @enemy.health = math.min @enemy.health + 1, @enemy.max_health
      @enemy.damage = 0
    super dt

  draw: =>
    super!
