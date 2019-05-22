-- Class for representing a Circle
export class Circle

  -- x: X coordinate of Circle center
  -- y: Y coordinate of Circle center
  -- radius: Radius of the Circle
  new: (x = 0, y = 0, radius = 1) =>
    -- Assign values
    @center = Point x, y
    @radius = radius

  -- Check if this Circle contains a Circle
  -- circ: The Circle to check for
  contains: (circ) =>
    switch circ.__class.__name
      when "Circle"
        -- Expand this circle
        @radius += circ.radius

        -- Find the Point to check collision with
        point = circ.center

        -- Get a 1D Vector from the Points
        x = point.x - @center.x
        y = point.y - @center.y

        -- Get distance between the points
        distance = (x * x) + (y * y)

        -- Check for collision and distance
        colliding = distance <= (@radius * @radius)
        collision_distance = distance - (@radius * @radius)

        -- Contract this circle
        @radius -= circ.radius

        -- Return the results
        return colliding, collision_distance
      when "Rectangle"
        return circ\contains @

  -- Get the extent of the collision with a Circle
  -- circ: The Circle to check
  getCollisionDistance: (circ) =>
    -- Check for a collision
    colliding, collision_distance = @contains circ

    -- Return the distance
    if colliding
      return -collision_distance
    else
      return 0

  -- Get the center Point of this Circle
  getCenter: =>
    return @center

  -- Set the center Point of the Circle
  -- point: The new center
  setCenter: (point) =>
    @center = point

  -- Get the radius of this Circle
  getRadius: =>
    return @radius

  -- Set the radius of this Circle
  -- radius: The new radius
  setRadius: (radius) =>
    @radius = radius

  draw: =>
    setColor 0, 255, 0, 255
    love.graphics.circle "line", @center.x, @center.y, @radius, 360
