export class ExtraLifePassive extends PassiveItem
  @lowest_rarity = 5
  new: (rarity) =>
    @rarity = rarity
    sprite = Sprite "item/extraLife.tga", 26, 26, 1, 56 / 26
    effect = (player) =>
      player.lives += 1
    super sprite, nil, effect
    @name = "Evil Dead"
    @description = "Gives an extra life"

  unequip: (player) =>
    super player
    player.lives = 1
