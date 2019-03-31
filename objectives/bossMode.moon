export class BossMode extends Mode
  new: (parent) =>
    super parent
    @objective_text = "Eliminate the boss"
    @mode_type = ModeTypes.boss
    @resetBosses!

  resetBosses: =>
    bosses = {
      BossTest,
      BossVyder,
      BossSerpent
    }
    shuffle bosses
    @bosses = LinkedList!
    for k, boss in pairs bosses
      @bosses\add boss

    n = @bosses.head
    s = ""
    while n
      s ..= n.data.__class.__name
      if n.next
        s ..= ", "
      n = n.next
    print s

  nextWave: =>
    super!
    if @bosses.length == 0
      @resetBosses!
    boss = @bosses\remove!
    @wave = BossWave @, boss

  finish: =>
    super!
    Objectives.bosses_beaten += 1

  update: (dt) =>
    if not @complete
      if not @started
        @start!
      if not @wave.complete
        @wave\update dt
        level = Objectives\getLevel! + 1
        @message2 = "Level " .. level
        if @wave.complete
          @wave\finish!
      else
        @parent.difficulty += 2
        @complete = true
        @started = false
