export class MissileActive extends ActiveItem
  new: (rarity) =>
    @rarity = rarity
    cd = ({15, 14, 13, 12, 11})[@rarity]
    sprite = Sprite "projectile/missile.tga", 32, 16, 1, 1.75
    effect = (player) =>
      angle = 2 * math.pi * (1 / @num_missiles)
      point = Vector player\getHitBox!.radius + (10 * Scale.diag), 0
      for i = 1, @num_missiles
        missile = Missile player.position.x + point.x, player.position.y + point.y
        Driver\addObject missile, EntityTypes.bullet
        point\rotate angle
    super sprite, cd, effect
    @name = "Missile-lanious"
    @description = "Launch a number of missiles"
    @num_missiles = ({2, 3, 4, 5, 6})[@rarity]

  getStats: =>
    stats = super!
    table.insert stats, "Missiles: " .. @num_missiles
    return stats
