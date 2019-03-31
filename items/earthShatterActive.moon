export class EarthShatterActive extends ActiveItem
  new: (rarity) =>
    @rarity = rarity
    cd = ({20, 18, 16, 14, 12})[@rarity]
    sprite = Sprite "item/earthShatterActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      if player.speed\getLength! == 0
        for i = 0, 300, 60
          x = 138 * Scale.width
          v = Vector x, 0
          v\rotate (i / 180) * math.pi
          v\add player.position
          x, y = v\getComponents!
          angle = (i / 180) * math.pi
          @createShatter x, y, angle + (math.pi / 2)
      else
        angle = player.speed\getAngle!
        for i = 1, 6
          x = (i - 1) * (96 * Scale.width)
          v = Vector x, 0
          v\rotate angle
          v\add player.position
          x, y = v\getComponents!
          @createShatter x, y, angle + (math.pi / 2)
    super sprite, cd, effect
    @name = "School Zone"
    @description = "Slow enemies"
    @effect_time = 6

  createShatter: (x, y, angle) =>
    shatter = FrostField x, y
    shatter.sprite = Sprite "background/earthShatter.tga", 32, 32, 1, 6
    shatter.sprite.color[4] = 200
    shatter.sprite.rotation = angle
    shatter.life_time = 6
    shatter.frost_delay = 0.2
    Driver\addObject shatter, EntityTypes.background
