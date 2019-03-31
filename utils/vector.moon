-- Class for representing Vector objects
export class Vector

  -- x: X value of the Vector
  -- y: Y value of the Vector
  -- isUnit: Whether the Vector should be a unit Vector
  new: (x = 0, y = 0, isUnit = false) =>
    -- Assign x and y
    @x = x
    @y = y

    -- Convert to unit Vector
    if isUnit
      @toUnitVector!

  -- Gets the Pythagorean length of the Vector
  getLength: =>
    return math.sqrt (@x * @x) + (@y * @y)

  -- Convert the Vector to a unit vector by dividing by length
  toUnitVector: =>
    length = @getLength!
    if length > 0
      @x /= length
      @y /= length

  -- Gets the angle between 2 vectors
  -- vec: The other vector
  getAngleBetween: (vec) =>
    -- Get the angle of a new Vector from vec to this
    angle = math.atan2 @y - vec.y, @x - vec.x

    -- Add half a rotation to account for orientation
    return angle + (math.pi / 2)

  -- Gets the angle of this Vector
  getAngle: =>
    angle = @getAngleBetween Vector 0, 0
    return angle - (math.pi / 2)

  -- Gets the distance between 2 vectors
  -- vec: The other Vector
  getDistanceBetween: (vec) =>
    -- Create a new Vector from vec to this
    newVec = Vector @x - vec.x, @y - vec.y

    -- Return the length of the new Vector
    return newVec\getLength!

  -- Rotate this Vector
  -- angle: The angle to rotate by
  rotate: (angle) =>
    -- Get cos and sin of the angle
    cos_angle, sin_angle = (math.cos angle), (math.sin angle)

    -- Rotate x and y
    x = (cos_angle * @x) - (sin_angle * @y)
    y = (sin_angle * @x) + (cos_angle * @y)

    -- Set x and y
    @x = x
    @y = y

  -- Add a Vector to this
  -- vec: The Vector to add to this
  add: (vec) =>
    -- Add the other x and y to this
    @x += vec.x
    @y += vec.y

  -- Get a Vector resulting from scaling this one by a factor
  -- factor: The factor to scale this Vector by
  multiply: (factor) =>
    -- Return a new scaled Vector
    return Vector @x * factor, @y * factor

  -- Get the magnitude Vector from this vector
  getAbsolute: =>
    -- Get absolute value
    x = math.abs @x
    y = math.abs @y

    -- Return absolute Vector
    return Vector x, y

  -- Get the x and y of this Vector
  getComponents: =>
    -- Return x and y
    return @x, @y

  -- Get the string representation of this Vector
  __tostring: =>
    -- Return this Vector as a point representation
    return "(" .. @x .. ", " .. @y ..")"
