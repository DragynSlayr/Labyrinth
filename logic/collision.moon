export class CollisionChecker
  update: (dt) =>
    player = MainPlayer\getHitBox!
    reset_player = false

    for k, handler in pairs MainPlayer.colliders
      for k2, o in pairs handler.objects[World.idx]
        other = o\getHitBox!
        if other\contains player
          if o.solid
            o.position = o.last_position\getCopy!
            -- o.position\add (o.speed\multiply (-dt * 3))
            reset_player = true
            if o.contact_damage
              MainPlayer\onCollide o

    handlers = {EnemyHandler, BossHandler}
    for k, w in pairs WallHandler.objects[World.idx]
      if w.enabled
        wall = w\getHitBox!
        if wall\contains player
          reset_player = true
        for k, handler in pairs handlers
          for k2, o in pairs handler.objects[World.idx]
            b = o\getHitBox!
            if b\contains wall
              o.position = o.last_position\getCopy!
              -- o.position\add (o.speed\multiply (-dt * 3))

    -- for k1, o1 in pairs EnemyHandler.objects[World.idx]
    --   b1 = o1\getHitBox!
    --   for k2, o2 in pairs EnemyHandler.objects[World.idx]
    --     if o1 != o2
    --       b2 = o2\getHitBox!
    --       if b1\contains b2
    --         if math.random! > 0.5
    --           o1.position = o1.last_position\getCopy!
    --           -- o1.position\add (o1.speed\multiply (-dt * 3))
    --         else
    --           o2.position = o2.last_position\getCopy!
    --           -- o2.position\add (o2.speed\multiply (-dt * 3))

    if reset_player
      MainPlayer.position = MainPlayer.last_position\getCopy!
    else
      MainPlayer.last_position = MainPlayer.position\getCopy!

    handlers = {EnemyHandler, BossHandler}
    for k, handler in pairs handlers
      for k2, o in pairs handler.objects[World.idx]
        o.last_position = o.position\getCopy!
