export class AttackCloneActive extends ActiveItem
  @lowest_rarity = 3
  new: (rarity) =>
    @rarity = rarity
    cd = 5
    sprite = Sprite "background/clone.tga", 32, 32, 1, 1.75
    sprite\setRotationSpeed math.pi / 2
    effect = (player) =>
      clone = AttackClone player
      clone.max_time = @duration
      clone.max_health = @duration
      Driver\addObject clone, EntityTypes.background
    super sprite, cd, effect
    @name = "2.0"
    @description = "Summons another you"
    @duration = ({0, 0, 10, 15, 20})[@rarity]

  getStats: =>
    stats = super!
    table.insert stats, "Duration: " .. @duration .. "s"
    return stats
