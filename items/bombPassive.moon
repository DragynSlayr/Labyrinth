export class BombPassive extends PassiveItem
  new: (rarity) =>
    @rarity = rarity
    cd = ({7, 6, 5, 4, 3})[@rarity]
    sprite = Sprite "item/bomb.tga", 32, 32, 1, 1.75
    effect = (player) =>
      x = math.random 0, Screen_Size.width
      y = math.random 0, Screen_Size.height
      bomb = Bomb x + player.position.x - Screen_Size.width, y + player.position.y - Screen_Size.height
      bomb.attack_range = 33 * Scale.diag
      Driver\addObject bomb, EntityTypes.background
    super sprite, cd, effect
    @name = "Tele-frag"
    @description = "A bomb randomly spawns on the screen"
