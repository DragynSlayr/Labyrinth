export class TrailPassive extends PassiveItem
  new: (rarity) =>
    @rarity = rarity
    @life_time = ({1.5, 1.75, 2, 2.25, 2.5})[@rarity]
    sprite = Sprite "item/trailPassive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      sprite = Sprite "item/trailPassive.tga", 32, 32, 1, 1.75
      trail = ParticleTrail player.position.x, player.position.y, sprite, player
      trail.life_time = @life_time
      trail.particle_type = ParticleTypes.enemy_poison
      @trail = trail
      Driver\addObject @trail, EntityTypes.particle
    super sprite, nil, effect
    @name = "Straight Contamination"
    @description = "A trail of poison follows the player"

  getStats: =>
    stats = super!
    table.insert stats, "Length: " .. @life_time
    return stats

  unequip: (player) =>
    super player
    Driver\removeObject @trail, false
