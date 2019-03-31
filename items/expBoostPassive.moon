export class ExpBoostPassive extends PassiveItem
  new: (rarity) =>
    @rarity = rarity
    @amount = ({1.2, 1.25, 1.3, 1.35, 1.4})[@rarity]
    sprite = Sprite "item/expBoost.tga", 24, 24, 1, 56 / 24
    effect = (player) =>
      player.exp_multiplier *= @amount
    super sprite, nil, effect
    @name = "Xtreme Progress"
    @description = "Raises player exp by " .. ((@amount - 1) * 100) .. "%"

  unequip: (player) =>
    super player
    player.exp_multiplier /= @amount
