export class DashActive extends ActiveItem
  @lowest_rarity = 5
  new: (rarity) =>
    @rarity = rarity
    cd = ({5, 4, 3, 2, 1})[@rarity]
    sprite = Sprite "item/dashActive.tga", 32, 32, 1, 1.75
    effect_sprite = Sprite "background/roomDoor.tga", 32, 32, 1, 4
    delay = 0.25
    effect = (player) =>
      x, y = player.speed\getComponents!
      sum = (math.abs x) + (math.abs y)
      if sum > 0
        p1 = Particle player.position.x - Screen_Size.half_width, player.position.y - Screen_Size.half_height, effect_sprite, 255, 127, delay
        Driver\addObject p1, EntityTypes.particle

        speed = Vector x, y, true
        player.position\add speed\multiply (Scale.diag * 350)

        Timer delay, @, (() =>
          p2 = Particle player.position.x - Screen_Size.half_width, player.position.y - Screen_Size.half_height, effect_sprite, 127, 255, delay
          Driver\addObject p2, EntityTypes.particle
        ), false
    super sprite, cd, effect
    @name = "Insain Bolt"
    @description = "Dash in the direction you are moving"
