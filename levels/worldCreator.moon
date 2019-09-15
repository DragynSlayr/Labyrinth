export class WorldCreator
  new: =>
    @createWorld1!

    @createDoors!
    @setupSpawners!

  createWorld1: =>
    World\goto 1

    text = {"Hello, welcome to the starting area of this game, click to continue", "Would you like to take a quest?", "Nice, go kill 2 of these basic enemies", "Come back later then"}
    npc = NPC 2680, 2000, "Ted", text

    npc\setPath {
      {(Vector 100, 0), 2.5},
      {(Vector 0, 100), 3},
      {(Vector -100, 0), 2.5},
      {(Vector 0, -100), 3}
    }

    npc\addButton 2, "Yes", (parent) ->
      parent\goto 3
    npc\addButton 2, "No", (parent) ->
      parent\goto 4

    npc\addButton 3, "Bye", (parent) ->
      timer = Timer 1, @, (() =>
        Driver.spawn (BasicEnemy), EnemyHandler
      ), true
      q = Quest QuestTypes.kill, (BasicEnemy), 2
      q.callback = () =>
        timer.done = true
        MainPlayer\addExp 500
        MainPlayer\addCoins 200
      parent\finish!

    npc\addButton 4, "Bye", (parent) ->
      parent\finish!

    positions = {
      {550, 2090},
      {375, 2210},
      {550, 2330}
    }
    for i = 1, 3
      item = ItemPool\getItem!
      x, y = unpack positions[i]
      ped = ItemPedestal x, y, item, item.rarity * 10
      ped.refilling = true

  createDoors: =>
    TownDoor {51, 1, 1}, {49, 97, 2}

  setupSpawners: =>
    World.spawners[1][1]\setup (CloudEnemy), 0.5, true
    World.spawners[1][1].limit = 1
