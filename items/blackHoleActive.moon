export class BlackHoleActive extends ActiveItem
  @lowest_rarity = 5
  new: (rarity) =>
    @rarity = rarity
    cd = ({20, 18, 16, 14, 12})[@rarity]
    sprite = Sprite "background/blackhole.tga", 32, 32, 1, 1.75
    sprite\setRotationSpeed -math.pi / 2
    effect = (player) =>
      hole = BlackHole player.position.x - Screen_Size.half_width, player.position.y - Screen_Size.half_height
    super sprite, cd, effect
    @name = "Sucky thingy"
    @description = "Places a black hole that sucks in enemies"
    @effect_time = 7.5
