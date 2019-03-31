export class PassiveItem extends Item
  new: (sprite, delay = -1, effect) =>
    super sprite
    @item_type = ItemTypes.passive
    @effect = effect
    @delay = delay

  getStats: =>
    stats = super!
    if @delay > 0
      s = string.format "Frequency: %.2fs", @delay
      table.insert stats, s
    return stats

  pickup: (player) =>
    super player
    if @delay == -1
      @effect @player

  update2: (dt) =>
    super dt
    if @delay ~= -1 and @timer >= @delay
      @timer = 0
      @effect @player
