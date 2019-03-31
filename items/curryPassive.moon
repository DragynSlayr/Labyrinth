export class CurryPassive extends PassiveItem
  @lowest_rarity = 5
  new: (rarity) =>
    @rarity = rarity
    @amount = ({1.3, 1.35, 1.4, 1.45, 1.5})[@rarity]
    sprite = Sprite "item/curryPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      player.max_health *= @amount
      player.health = player.max_health
      player.attack_range *= @amount
      player.damage *= @amount
      player.max_speed *= @amount
      player.attack_speed /= @amount
    super sprite, nil, effect
    @name = "Hearty Curry"
    @description = "Raises all player stats by " .. ((@amount - 1) * 100) .. "%"

  unequip: (player) =>
    super player
    player.max_health /= @amount
    player.health = player.max_health
    player.attack_range /= @amount
    player.damage /= @amount
    player.max_speed /= @amount
    player.attack_speed /= @amount
