export class FreezeFieldActive extends ActiveItem
  new: (rarity) =>
    @rarity = rarity
    cd = ({15, 14, 13, 12, 11})[@rarity]
    sprite = Sprite "background/frostField.tga", 32, 32, 2, 1.75
    effect = (player) =>
      field = FrostField player.position.x - Screen_Size.half_width, player.position.y - Screen_Size.half_height
      Driver\addObject field, EntityTypes.background
    super sprite, cd, effect
    @name = "-273.15 Celsius"
    @description = "Place a freezing field"
    @effect_time = 7.5
