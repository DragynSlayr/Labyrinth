export class ItemBox extends Item
  new: =>
    @rarity = 1
    sprite = Sprite "item/box.tga", 32, 32, 1, 1.75
    super sprite
    @name = "Item Box"
    @description = "Open to get a random item"
