export class WholeHogActive extends ActiveItem
  @lowest_rarity = 5
  new: (rarity) =>
    @rarity = rarity
    cd = ({20, 19, 18, 17, 16})[@rarity]
    sprite = Sprite "item/wholeHogActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      @player.knocking_back = true
    super sprite, cd, effect
    @name = "Rejection"
    @description = "Player bullets do knockback"
    @effect_time = ({10, 11, 12, 13, 14})[@rarity]
    @onEnd = () -> @player.knocking_back = false

  getStats: =>
    stats = super!
    table.insert stats, "Duration: " .. @effect_time .. "s"
    return stats
