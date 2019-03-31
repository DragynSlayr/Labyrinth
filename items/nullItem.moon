export class NullItem extends Item
  @probability = 0
  new: =>
    @rarity = 1
    sprite = Sprite "item/empty.tga", 32, 32, 1, 1.75
    super sprite
    @name = "Empty"
    @description = "No item in this slot"

  getCopy: =>
    item = NullItem!
    item.name = @name
    item.description = @description
    item.sprite = Sprite "item/empty.tga", 32, 32, 1, 1.75
    return item
