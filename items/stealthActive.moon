export class StealthActive extends ActiveItem
  @highest_rarity = 3
  new: (rarity) =>
    @rarity = rarity
    cd = 7
    sprite = Sprite "item/stealthActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      @clone = AttackClone player
      @clone.draw_health = false
      @clone.max_time = @effect_time
      @clone.max_health = player.max_health * 20
      @clone.bullet_time = @effect_time + 1
      @clone.sprite\setColor {255, 255, 255, 0}
      @clone.keypressed = (_) => return
      @clone.keyreleased = (_) => return
      @clone.hasItem = (_) => return false
      @clone.exp_multiplier = 0
      @clone.exp = 0
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
