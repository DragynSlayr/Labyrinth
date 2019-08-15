export class DeadEyeActive extends ActiveItem
  new: (rarity) =>
    @rarity = rarity
    cd = ({15, 14, 13, 12, 11})[@rarity]
    sprite = Sprite "item/deadeyeActive.tga", 32, 32, 1, 1.75
    effect = (player) =>
      player.movement_blocked = true
      @damage = 0
    super sprite, cd, effect
    @name = "12 O'clock"
    @description = "Take aim and fire"
    @effect_time = 6
    @effect_timer = 0
    @damage = 0
    @damage_scale = 0
    @damage_multiplier = ({1, 1.1, 1.2, 1.3, 1.4})[@rarity]
    @effect_sprite = Sprite "effect/deadeye.tga", 32, 32, 1, 1.75

  getStats: =>
    stats = super!
    table.insert stats, "Damage Multiplier: " .. @damage_multiplier
    return stats

  fire: =>
    filters = {EnemyHandler, BossHandler}
    for k2, filter in pairs filters
      for k, v in pairs filter.objects
        if v\isOnScreen!
          v\onCollide @
    @effect_timer = 0
    @damage = 0
    @used = false
    @player.movement_blocked = false

  pickup: (player) =>
    super player
    @damage_scale = player.damage * 10 * @damage_multiplier

  use: =>
    if @used
      @fire!
    elseif @charged
      @timer = 0
      @charged = false
      @effect @player
      @used = true
    else
      print "On Cooldown: " .. math.floor (@charge_time - @timer)

  update2: (dt) =>
    if @used
      @effect_sprite\update dt
      @effect_timer += dt
      @damage += @damage_scale * dt
      if @effect_timer >= @effect_time
        @fire!
      @sprite.shader\send "amount", 1
    else
      @timer += dt
      if not @charged and @timer >= @charge_time
        @timer = 0
        @charged = true
      amount = 0
      if not @charged
        amount = 1 - (@timer / @charge_time)
      @sprite.shader\send "amount", amount

  draw2: =>
    super!
    if @used
      love.graphics.push "all"
      love.graphics.setShader Driver.shader

      filters = {EnemyHandler, BossHandler}
      for k2, filter in pairs filters
        for k, v in pairs filter.objects
          if v.health + v.armor <= @damage
            @effect_sprite\draw v.position.x, v.position.y

      love.graphics.setShader!
      love.graphics.pop!
