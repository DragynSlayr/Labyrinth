export class DragonStrikeActive extends ActiveItem
  new: (rarity) =>
    @rarity = rarity
    cd = ({18, 16, 14, 12, 10})[@rarity]
    sprite = Sprite "item/dragonStrikeActive.tga", 32, 32, 1, 1.75
    sprite\setRotationSpeed -math.pi / 3
    effect = (player) =>
      if player.speed\getLength! == 0
        for i = 0, 300, 60
          x = 138 * Scale.width
          v = Vector x, 0
          v\rotate (i / 180) * math.pi
          v\add player.position
          x, y = v\getComponents!
          r = -1
          f = false
          if (i / 60) % 2 == 1
            r = 1
            f = true
          @createDragon x, y, r, f
      else
        angle = player.speed\getAngle!
        for i = 1, 6
          x = (i - 1) * (96 * Scale.width)
          v = Vector x, 0
          v\rotate angle
          v\add player.position
          @createDragon v\getComponents!
    super sprite, cd, effect
    @name = "Long Snake"
    @description = "Summon a dragon"
    @effect_time = 6

  createDragon: (x, y, r = -1, f = false) =>
    dragon = PoisonField x, y
    dragon.sprite = Sprite "background/dragonStrike.tga", 32, 32, 1, 6
    dragon.sprite.color[4] = 200
    dragon.sprite\setRotationSpeed math.pi / (3 * r)
    if f
      dragon.sprite.x_scale *= -1
    dragon.life_time = 6
    dragon.poison_amount = 1
    Driver\addObject dragon, EntityTypes.background
