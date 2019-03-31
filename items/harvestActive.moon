export class HarvestActive extends ActiveItem
  @lowest_rarity = 5
  new: (rarity) =>
    @rarity = rarity
    sprite = Sprite "item/harvestActive.tga", 32, 32, 1, 1.75
    sprite\setRotationSpeed (math.pi / 6)
    effect = (player) =>
      @old = {}
      @old[1] = player.max_shield_time
      @old[2] = player.damage
      @old[3] = player.shield_sprite
      @old[4] = @player.sprite.color
      @old[5] = @player.createBullet
      player.shield_sprite = Sprite "effect/rageShield.tga", 32, 32, 1, 2
      player.shield_sprite\setRotationSpeed (math.pi / 2)
      player.shielded = true
      player.shield_timer = 0
      player.max_shield_time = @start_effect_time
    super sprite, 10, effect
    @name = "Harvest"
    @description = "Kill to gain power"
    @start_effect_time = 10
    @start_effect_delta = 3
    @start_target_delta = 3
    @start_target_count = 3
    @kill_count = 0
    @last_target = 0
    @old = {}
    @color_changed = false
    @resetCounters!
    @onEnd = () =>
      @player.shielded = false
      @player.shield_timer = 0
      @player.max_shield_time = @old[1]
      @player.damage = @old[2]
      @player.shield_sprite = @old[3]
      @player.sprite.color = @old[4]
      @player.createBullet = @old[5]
      @color_changed = false
      @resetCounters!

  resetCounters: =>
    @effect_time = @start_effect_time
    @effect_delta = @start_effect_delta
    @target_delta = @start_target_delta
    @target_count = @start_target_count
    @kill_count = 0
    @last_target = 0

  getStats: =>
    stats = super!
    stats[#stats] = "Base " .. stats[#stats]
    return stats

  onKill: (entity) =>
    if @used
      if entity.id == EntityTypes.enemy and entity.__class != CaptureEnemy
        @kill_count += 1
        if @kill_count >= @target_count
          @last_target = @target_count

          @target_count += @target_delta
          @target_delta += 1

          @player.damage += @effect_delta / 4
          @player.shield_timer = clamp @player.shield_timer - @effect_delta, 0, @player.shield_timer
          @player.max_shield_time += @effect_delta
          @effect_timer = clamp @effect_timer - @effect_delta, 0, @effect_timer
          @effect_time += @effect_delta
          @effect_delta *= 0.95

          if not @color_changed
            @color_changed = true
            @old[4] = @player.sprite.color
            @old[5] = @player.fireBullet
            @player.sprite\setColor {0, 0, 0, 255}
            @player.createBullet = (x, y, damage, speed, filters) =>
              bullet = FilteredBullet x, y, damage, speed, filters
              bullet.sprite\setColor {0, 0, 0, 255}
              return bullet

  update2: (dt) =>
    if @used
      @charge_time = @effect_time + @timer
      r = (@kill_count - @last_target) / (@target_count - @last_target)
      @player.shield_sprite\setColor {r * 255, 0, 0, 255}
    super dt
