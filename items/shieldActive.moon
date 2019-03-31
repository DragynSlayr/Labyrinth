export class ShieldActive extends ActiveItem
  new: (rarity) =>
    @rarity = rarity
    cd = ({20, 18, 16, 14, 12})[@rarity]
    sprite = Sprite "item/shield.tga", 32, 32, 1, 1.75
    effect = (player) =>
      player.shielded = true
    super sprite, cd, effect
    @name = "Own-guard"
    @description = "Gives a temporary shield"
    @effect_time = 7
