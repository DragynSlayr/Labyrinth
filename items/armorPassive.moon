export class ArmorPassive extends PassiveItem
  @lowest_rarity = 3
  new: (rarity) =>
    @rarity = rarity
    cd = ({0.5, 0.4, 0.3, 0.2, 0.1})[@rarity]
    sprite = Sprite "item/armorPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      player\setArmor player.armor + (player.max_armor * 0.001), player.max_armor
    super sprite, cd, effect
    @name = "ArMORE"
    @description = "Provides armor over time"
