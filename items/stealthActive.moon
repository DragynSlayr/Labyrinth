export class StealthActive extends ActiveItem
  @highest_rarity = 3
  new: (rarity) =>
    @rarity = rarity
    cd = 7
    sprite = Sprite "item/stealthActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      @clone = Player player.position.x - Screen_Size.half_width, player.position.y - Screen_Size.half_height
      @clone\pickClass 0
      @clone\updateStats true
      @clone.is_clone = true
      @clone.draw_health = false
      @clone.show_stats = false
      @clone.solid = false
      @clone.sprite\setColor {100, 100, 100, 100}
      @clone.onCollide = (_) =>
        return
      @clone.kill = () =>
        return

      player.old_color = player.sprite.color
      player.sprite\setColor {200, 200, 200, 127}
      Driver\addObject @clone, EntityTypes.player
    super sprite, cd, effect
    @name = "Ghost"
    @description = "Hide from enemies"
    @effect_time = ({4, 5, 6, 0, 0})[@rarity]
    @onEnd = () ->
      Driver\removeObject @clone, false
      @clone = nil
      @player.sprite\setColor @player.old_color
      @player.old_color = nil

  getStats: =>
    stats = super!
    table.insert stats, "Duration: " .. @effect_time .. "s"
    return stats
