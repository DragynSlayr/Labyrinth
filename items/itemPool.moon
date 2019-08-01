export class ItemPoolHandler
  new: =>
    @items = {
      EMPActive,
      BombActive,
      DashActive,
      CharmActive,
      CloneActive,
      TrailActive,
      JacketActive,
      DeadEyeActive,
      MissileActive,
      StealthActive,
      WholeHogActive,
      BlackHoleActive,
      MoltenCoreActive,
      FreezeFieldActive,
      PoisonFieldActive,
      SoulCollectActive,
      DragonStrikeActive,
      EarthShatterActive,
      HealingFieldActive,
      BombPassive,
      TrailPassive,
      MissilePassive,
      ExtraLifePassive,
      HealthBoostPassive,
      StutterShotPassive,
      DamageAbsorbPassive,
      DamageReflectPassive
    }
    @generatePool!

    chances = {38, 28, 17, 12, 5}--{50, 26, 15, 8, 1}
    @chances = {}
    for i = 1, 4
      sum = 0
      for j = 1, 5 - i
        sum += chances[j]
      @chances[i] = sum

  generatePool: =>
    new_items = {}
    for i = 1, 5
      new_items[i] = {}
    for idx, item in pairs @items
      for i = item.lowest_rarity, item.highest_rarity
        for j = 1, item.probability
          table.insert new_items[i], item
    @items = new_items

  getItem: =>
    rarity = 1
    num = math.random! * 100
    if num >= @chances[1]
      rarity = 5
    elseif num >= @chances[2]
      rarity = 4
    elseif num >= @chances[3]
      rarity = 3
    elseif num >= @chances[4]
      rarity = 2

    item = pick @items[rarity]
    return (item rarity)
