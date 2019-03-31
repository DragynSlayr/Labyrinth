export class DashActive extends ActiveItem
  @lowest_rarity = 5
  new: (rarity) =>
    @rarity = rarity
    cd = ({5, 4, 3, 2, 1})[@rarity]
    sprite = Sprite "item/dashActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      x, y = player.speed\getComponents!
      sum = (math.abs x) + (math.abs y)
      if sum > 0
        speed = Vector x, y, true
        player.position\add speed\multiply (Scale.diag * 350)
        radius = player\getHitBox!.radius
        player.position.x = clamp player.position.x, Screen_Size.border[1] + radius, Screen_Size.border[3] - radius
        player.position.y = clamp player.position.y, Screen_Size.border[2] + radius, (Screen_Size.border[4] + Screen_Size.border[2]) - radius
    super sprite, cd, effect
    @name = "Insain Bolt"
    @description = "Dash in the direction you are moving"
