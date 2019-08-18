export class CollisionChecker
  update: (dt) =>
    player = MainPlayer\getHitBox!
    for k, handler in pairs MainPlayer.colliders
      for k2, o in pairs handler.objects
        other = o\getHitBox!
        if other\contains player
          if o.solid
            o.position = o.last_position
            o.position\add (o.speed\multiply (-dt * 3))
            MainPlayer.position = MainPlayer.last_position
            MainPlayer.position\add (MainPlayer.speed\multiply (-dt * 3))
            if o.contact_damage
              MainPlayer\onCollide o

    handlers = {EnemyHandler, BossHandler}
    for k, w in pairs WallHandler.objects
      wall = w\getHitBox!
      if wall\contains player
        MainPlayer.position = MainPlayer.last_position
        MainPlayer.position\add (MainPlayer.speed\multiply (-dt * 3))
      for k, handler in pairs handlers
        for k2, o in pairs handler.objects
          b = o\getHitBox!
          if b\contains wall
            o.position = o.last_position
            o.position\add (o.speed\multiply (-dt * 3))

    for k1, o1 in pairs EnemyHandler.objects
      b1 = o1\getHitBox!
      for k2, o2 in pairs EnemyHandler.objects
        if o1 != o2
          b2 = o2\getHitBox!
          if b1\contains b2
            if math.random! > 0.5
              o1.position = o1.last_position
              o1.position\add (o1.speed\multiply (-dt * 3))
            else
              o2.position = o2.last_position
              o2.position\add (o2.speed\multiply (-dt * 3))

    MainPlayer.last_position = MainPlayer.position
    handlers = {EnemyHandler, BossHandler}
    for k, handler in pairs handlers
      for k2, o in pairs handler.objects
        o.last_position = o.position
