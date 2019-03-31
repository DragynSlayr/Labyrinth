-- Class for representing 2D Points
export class Point

  -- x: X coordinate of the Point
  -- y: Y coordinate of the Point
  new: (x = 0, y = 0) =>
    @x = x
    @y = y

  -- Rotate the Point
  -- angle: The angle to rotate by
  rotate: (angle) =>
    -- Create a Vector with this Point
    vec = Vector @x, @y

    -- Rotate the Vector
    vec\rotate angle

    -- Set x and y from Vector
    @x, @y = vec\getComponents!

  -- Get the coordinates of this Point
  getComponents: =>
    return @x, @y

  -- Get the String representation of this Point
  __tostring: =>
    return "(" .. @x .. ", " .. @y ..")"
