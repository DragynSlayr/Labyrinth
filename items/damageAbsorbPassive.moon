export class DamageAbsorbPassive extends PassiveItem
  @lowest_rarity = 2
  @highest_rarity = 4
  new: (rarity) =>
    @rarity = rarity
    @chance = ({50, 55, 60, 65, 70})[@rarity]
    sprite = Sprite "item/damageAbsorbPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      health = player.health
      if health < @last_health
        difference = @last_health - health
        @last_health = health
        if math.random! >= ((100 - @chance) / 100)
          player.health += difference
    super sprite, 0, effect
    @name = "Ouchie Maybe"
    @description = "Has a chance to absorb incoming damage"

  getStats: =>
    stats = super!
    table.insert stats, "Absorb Chance: " .. @chance .. "%"
    return stats

  pickup: (player) =>
    super player
    @last_health = player.health
