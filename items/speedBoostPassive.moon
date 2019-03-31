export class SpeedBoostPassive extends PassiveItem
  new: (rarity) =>
    @rarity = rarity
    @amount = ({1.2, 1.25, 1.3, 1.35, 1.4})[@rarity]
    sprite = Sprite "item/speedBoost.tga", 24, 24, 1, 56 / 24
    effect = (player) =>
      player.max_speed *= @amount
    super sprite, nil, effect
    @name = "Breezy"
    @description = "Raises player speed by " .. ((@amount - 1) * 100) .. "%"

  unequip: (player) =>
    super player
    player.max_speed /= @amount
