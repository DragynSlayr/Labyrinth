export class Color
  new: (r = 0, g = 0, b = 0, a = 255) =>
    @r = r
    @g = g
    @b = b
    @a = a

  get: =>
    return @r, @g, @b, @a

  equals: (color) =>
    r, g, b, a = color\get!
    return r == @r and g == @g and b == @b and a == @a
