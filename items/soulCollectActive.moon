export class SoulCollectActive extends ActiveItem
  @lowest_rarity = 2
  new: (rarity) =>
    @rarity = rarity
    cd = ({8, 9, 10, 11, 12})[@rarity]
    sprite = Sprite "item/soulCollectActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      for k, v in pairs Driver.objects[EntityTypes.enemy]
        v.old = {}
        v.old[1] = v.sprite
        v.old[2] = v.update
        v.old[3] = v.contact_damage
        v.old[4] = v.damage
        v.old[5] = v.draw_health
        v.old[6] = v.solid
        v.is_soul = true

        v.sprite = Sprite "effect/soul.tga", 32, 32, 1, 1.5
        v.sprite\setRotationSpeed math.pi / 3
        v.update = (dt, other = false) =>
          @sprite\update dt
        v.contact_damage = true
        v.damage = 0
        v.draw_health = false
        v.solid = false
      player.old_collide = player.onCollide
      player.onCollide = (object) =>
        if object.is_soul
          object.health = 0
          @health += @max_health * 0.05
          @health = math.min @health, @max_health
        else
          @old_collide object
    super sprite, cd, effect
    @name = "Stop Fighting"
    @description = "Turn enemies into collectable souls"
    @effect_time = ({2, 4, 6, 8, 10})[@rarity]
    @onEnd = () ->
      for k, v in pairs Driver.objects[EntityTypes.enemy]
        if v.is_soul
          v.sprite = v.old[1]
          v.update = v.old[2]
          v.contact_damage = v.old[3]
          v.damage = v.old[4]
          v.draw_health = v.old[5]
          v.solid = v.old[6]
          v.old = nil
          v.is_soul = nil
      @player.onCollide = @player.old_collide
      @player.old_collide = nil

  getStats: =>
    stats = super!
    table.insert stats, "Duration: " .. @effect_time .. "s"
    return stats
