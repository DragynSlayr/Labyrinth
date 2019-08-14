export class BossWave extends Wave
  new: (parent, boss) =>
    super parent
    @boss = boss

  entityKilled: (entity) =>
    if entity == @boss
      @complete = true
      if @boss.trail
        Driver\removeObject @boss.trail, false
      Objectives.shader = nil

  start: =>
    @boss = Objectives\spawn (@boss), EntityTypes.boss
    if @boss.shader
      Objectives.shader = @boss.shader

  draw: =>
    @parent.message1 = "BOSS BATTLE!!"
    super!
