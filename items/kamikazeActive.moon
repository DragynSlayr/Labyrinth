export class KamikazeActive extends ActiveItem
  new: (rarity) =>
    @rarity = rarity
    sprite = Sprite "item/kamikazeActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      return
    super sprite, 0, effect
    @name = "Kamikaze"
    @description = "Damage everything in an area"
    @radius = (({150, 175, 200, 225, 250})[@rarity]) * Scale.diag
    @effect_time = 1
    @onEnd = () =>
      temp_damage = @player.damage
      @player.damage = @player.health * 0.15
      @player\onCollide @player
      @player.damage = temp_damage

      filters = {EntityTypes.enemy, EntityTypes.boss}
      for k, v in pairs Driver.objects[EntityTypes.goal]
        if v.goal_type == GoalTypes.attack
          table.insert filters, EntityTypes.goal
          break
      for k2, filter in pairs filters
        for k, v in pairs Driver.objects[filter]
          p = @player\getHitBox!
          o = v\getHitBox!
          p.radius += @radius
          if p\contains o
            temp_damage = @player.damage
            @player.damage *= 10
            v\onCollide @player
            @player.damage = temp_damage

  getStats: =>
    stats = super!
    stats[#stats] = "Range: " .. @radius
    return stats

  draw2: =>
    super!
    if DEBUGGING or @used
      love.graphics.push "all"
      setColor 127, 127, 0, 127
      love.graphics.circle "fill", @player.position.x, @player.position.y, @player\getHitBox!.radius + @radius, 360
      love.graphics.pop!
