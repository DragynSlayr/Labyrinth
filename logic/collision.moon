class PairTable
  new: =>
    @colliding = {}

  addPair: (a, b) =>
    found = false
    for k, v in pairs @colliding
      if v[1] == b and v[2] == a
        found = true
        break
    if not found
      table.insert @colliding, {a, b}

  clear: =>
    @colliding = {}

export class CollisionChecker
  new: =>
    @pairs = PairTable!

  update: (dt) =>
    for k, v in pairs Driver.objects
      for k2, o in pairs v
        for k3, c in pairs o.colliders
          for k4, o2 in pairs Driver.objects[c]
            if o ~= o2
              other = o2\getHitBox!
              this = o\getHitBox!
              if (tableContains o2.colliders, k) and (other\contains this)
                @pairs\addPair o, o2
    for k, collision in pairs @pairs.colliding
      a = collision[1]
      b = collision[2]
      if not (a.charmed or b.charmed)
        if a.solid
          a.position = a.last_position
          if a.speed\getLength! > 0
            a.position\add (a.speed\multiply dt)
        if b.solid
          b.position = b.last_position
          if b.speed\getLength! > 0
            b.position\add (b.speed\multiply (-1 * dt))
      else
        a.position = a.last_position
        b.position = b.last_position
      if a.contact_damage
        b\onCollide a
      if b.contact_damage
        a\onCollide b
    @pairs\clear!
