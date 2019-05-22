export class Rectangle
  new: (x, y, width, height) =>
    @x = x
    @y = y
    @width = width
    @height = height
    @center = Point x + (width / 2), y + (height / 2)
    @corners = {(Point x, y), (Point x + width, y), (Point x + width, y + height), (Point x, y + height)}
    @radius = (math.max @width, @height) / 2

  contains: (obj) =>
    switch obj.__class.__name
      when "Circle"
        vec = Vector @center.x - obj.center.x, @center.y - obj.center.y
        angle = vec\getAngle! - (math.pi / 2)
        width = 2 * (math.sin angle) * obj.radius
        height = 2 * (math.cos angle) * obj.radius
        x = obj.center.x - (width / 2)
        y = obj.center.y - (height / 2)
        rec = Rectangle x, y, width, height
        if DEBUGGING
          Renderer\enqueue () -> rec\draw!
        return @\contains rec
      when "Rectangle"
        colliding_points = {}
        result = false
        for k, p in pairs @corners
          is_colliding, dist = obj\contains p
          if is_colliding
            colliding_points[#colliding_points + 1] = dist
            result = true
        for k, p in pairs obj.corners
          is_colliding, dist = @\contains p
          if is_colliding
            colliding_points[#colliding_points + 1] = dist
            result = true
        if result
          max = 0
          for k, v in pairs colliding_points
            if v > max
              max = v
          return true, max
        else
          return false, 0
      when "Point"
        in_x = obj.x >= @x and obj.x <= @x + @width
        in_y = obj.y >= @y and obj.y <= @y + @height
        result = in_x and in_y
        if result
          dist = Vector @x - obj.x, @y - obj.y
          return true, dist\getLength!
        else
          return false, 0

  getCollisionDistance: (circ) =>
    -- Check for a collision
    colliding, collision_distance = @contains circ

    -- Return the distance
    if colliding
      return -collision_distance
    else
      return 0

  draw: =>
    setColor 0, 255, 0, 255
    love.graphics.rectangle "line", @corners[1].x, @corners[1].y, @width, @height
