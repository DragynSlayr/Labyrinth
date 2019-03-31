export class DrunkActive extends ActiveItem
  new: (rarity) =>
    @rarity = rarity
    cd = ({11, 10, 9, 8, 7})[@rarity]
    sprite = Sprite "item/drunkActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      player.old_damage = player.damage
      player.damage *= 3
      @flipControls!
    super sprite, cd, effect
    @name = "Impaired Mode"
    @description = "Boosts damage, but controls are flipped"
    @effect_time = 5
    @onEnd = () =>
      @player.damage = @player.old_damage
      @player.old_damage = nil
      @flipControls!

  getStats: =>
    stats = super!
    table.insert stats, "Duration: " .. @effect_time .. "s"
    return stats

  flipControls: =>
    Controls.keys.MOVE_LEFT, Controls.keys.MOVE_RIGHT = Controls.keys.MOVE_RIGHT, Controls.keys.MOVE_LEFT
    Controls.keys.MOVE_UP, Controls.keys.MOVE_DOWN = Controls.keys.MOVE_DOWN, Controls.keys.MOVE_UP
    Controls.keys.SHOOT_LEFT, Controls.keys.SHOOT_RIGHT = Controls.keys.SHOOT_RIGHT, Controls.keys.SHOOT_LEFT
    Controls.keys.SHOOT_UP, Controls.keys.SHOOT_DOWN = Controls.keys.SHOOT_DOWN, Controls.keys.SHOOT_UP
