export class EMPActive extends ActiveItem
  @lowest_rarity = 3
  new: (rarity) =>
    @rarity = rarity
    cd = ({20, 18, 16, 14, 12})[@rarity]
    sprite = Sprite "item/emp.tga", 32, 32, 1, 1.75
    filters = {EnemyHandler, BossHandler}
    effect = (player) =>
      for k2, filter in pairs filters
        for k, v in pairs filter.objects
          v.movement_disabled = true
    super sprite, cd, effect
    @name = "Enemies Must Pause"
    @description = "Disables enemies"
    @effect_time = ({6, 7, 8, 9, 10})[@rarity]
    @onEnd = () ->
      for k2, filter in pairs filters
        for k, v in pairs filter.objects
          v.movement_disabled = false

  getStats: =>
    stats = super!
    table.insert stats, "Duration: " .. @effect_time .. "s"
    return stats
