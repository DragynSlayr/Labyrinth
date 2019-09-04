export class Spawner
  new: (x, y) =>
    @position = Vector x + Screen_Size.half_width, y + Screen_Size.half_height
    @radius = 150 * Scale.diag
    @spawned = {}
    @limit = 5
    @enemyType = nil
    @timer = Timer 0.5, @, (() =>
      for k, enemy in pairs @parent.spawned
        if not enemy.alive
          table.remove @parent.spawned, k
      if #@parent.spawned < @parent.limit
        vec = Vector (math.random! * @parent.radius), 0
        vec\rotate (math.random! * 2 * math.pi)
        x = @parent.position.x + vec.x - Screen_Size.half_width
        y = @parent.position.y + vec.y - Screen_Size.half_height
        enemy = @parent.enemyType x, y
        table.insert @parent.spawned, enemy
    ), true
    @timer.enabled = false

  setup: (enemyType, delay, start = false) =>
    @timer.delay = delay
    @timer.elapsed = 0
    @enemyType = enemyType
    if start
      @start!

  start: =>
    @timer.enabled = true

  stop: =>
    @timer.enabled = false

  draw: =>
    if not DEBUGGING return
    setColor 200, 200, 0, 175
    love.graphics.rectangle "fill", @position.x - 16, @position.y - 16, 32, 32
    setColor 200, 100, 0, 150
    love.graphics.circle "fill", @position.x, @position.y, @radius
