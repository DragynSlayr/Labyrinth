export class CloneActive extends ActiveItem
  @lowest_rarity = 4
  @highest_rarity = 4
  new: (rarity) =>
    @rarity = rarity
    cd = ({25, 24, 23, 22, 21})[@rarity]
    sprite = Sprite "player/test.tga", 16, 16, 2, 3.50
    sprite\setRotationSpeed -math.pi / 2
    effect = (player) =>
      @clone = Player player.position.x, player.position.y
      @clone.is_clone = true
      @clone.draw_health = true
      @clone.show_stats = false
      @clone.attack_speed = @effect_time + 1
      @clone.solid = false
      @clone.sprite\setColor {100, 100, 100, 200}
      @clone.kill = () =>
        return
      Driver\addObject @clone, EntityTypes.player
    super sprite, cd, effect
    @name = "Twinsies"
    @description = "Create a clone of yourself"
    @effect_time = ({7, 8, 9, 10, 11})[@rarity]
    @onEnd = () ->
      Driver\removeObject @clone, false
      @clone = nil

  getStats: =>
    stats = super!
    table.insert stats, "Duration: " .. @effect_time .. "s"
    return stats
