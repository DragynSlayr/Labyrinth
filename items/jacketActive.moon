export class JacketActive extends ActiveItem
  @lowest_rarity = 3
  new: (rarity) =>
    @rarity = rarity
    cd = ({30, 28, 26, 24, 22})[@rarity]
    sprite = Sprite "item/jacketActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      for k, v in pairs Driver.objects[EntityTypes.player]
        v.shielded = true
    super sprite, cd, effect
    @name = "Winter Jacket"
    @description = "Allies receive a temporary shield"
