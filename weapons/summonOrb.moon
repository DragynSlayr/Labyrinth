export class SummonOrb extends Weapon
  new: (player) =>
    sprite = Sprite "unused/wormhole.tga", 40, 40, 1, 1
    sprite.color = {20, 255, 100, 255}
    action = (x, y, button, isTouch) =>
      if button != 1 return
      @used = true
      sprite = Sprite "unused/wormhole.tga", 40, 40, 1, 1
      sprite.color = {50, 200, 200, 255}
      sprite\setRotationSpeed (-math.pi / 2)
      orb = GameObject @player.position.x - Screen_Size.half_width, @player.position.y - Screen_Size.half_height, sprite
      orb.elapsed = 0
      orb.delay = 2
      orb.player = @player
      orb.offset = (Vector x - @player.position.x, y - @player.position.y, true)\multiply (@player.sprite.scaled_height * 1.5)
      orb.draw_health = false
      orb.update = (dt) =>
        @sprite\update dt
        @position = Vector @player.position.x, @player.position.y
        @offset\rotate dt
        @position\add @offset
        @elapsed += dt
        if @elapsed >= @delay
          filters = {EntityTypes.enemy, EntityTypes.boss}
          for k, filter in pairs filters
            for k2, o in pairs Driver.objects[filter]
              target = o\getHitBox!
              bullet = @getHitBox!
              bullet.radius *= 5
              if target\contains bullet
                o\onCollide @
                @elapsed = 0
      Driver\addObject orb, EntityTypes.particle
      Timer 3, @, (() =>
        @parent.used = false
      ), false
      Timer 15, @, (() =>
        orb.health = 0
      ), false
    super player, sprite, action
    @damage = 3
