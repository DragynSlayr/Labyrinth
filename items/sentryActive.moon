export class SentryActive extends ActiveItem
  new: (rarity) =>
    @rarity = rarity
    sprite = Sprite "item/sentryActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      player.movement_blocked = true

      player.old = {}
      player.old[1] = player.damage
      player.old[2] = player.attack_speed
      player.old[3] = player.attack_range

      player.damage *= 2
      player.attack_speed /= 2
      player.attack_range *= 3
    cd = 10
    super sprite, cd, effect
    @name = "Sentry"
    @description = "Become the turret"
    @effect_time = cd
    @onEnd = () =>
      @player.movement_blocked = false

      @player.damage = @player.old[1]
      @player.attack_speed = @player.old[2]
      @player.attack_range = @player.old[3]
      @player.old = {}
