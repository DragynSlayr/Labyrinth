export class DamageBoostPassive extends PassiveItem
  new: (rarity) =>
    @rarity = rarity
    @amount = ({1.2, 1.25, 1.3, 1.35, 1.4})[@rarity]
    sprite = Sprite "item/damageBoostPassive.tga", 24, 24, 1, 56 / 24
    effect = (player) =>
      player.damage *= @amount
    super sprite, nil, effect
    @name = "Medium Hurt"
    @description = "Raises player damage by " .. ((@amount - 1) * 100) .. "%"

  unequip: (player) =>
    super player
    player.damage /= @amount
