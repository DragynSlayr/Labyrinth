export class HealingFieldActive extends ActiveItem
  new: (rarity) =>
    @rarity = rarity
    cd = ({15, 14, 13, 12, 11})[@rarity]
    sprite = Sprite "background/healingField.tga", 32, 32, 2, 1.75
    effect = (player) =>
      field = HealingField player.position.x - Screen_Size.half_width, player.position.y - Screen_Size.half_height
    super sprite, cd, effect
    @name = "Good Juice"
    @description = "Place a healing field"
    @effect_time = 6.5
