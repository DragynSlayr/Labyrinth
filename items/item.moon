export class Item extends GameObject
  @lowest_rarity = 1
  @highest_rarity = 5
  @probability = 1
  new: (sprite) =>
    super 0, 0, sprite
    @item_type = nil
    @collectable = true
    @draw_health = false
    @contact_damage = true
    @player = nil
    @timer = 0
    @solid = true
    @damage = 0
    @name = "No name"
    @description = "No description"
    @quote = nil

  getStats: =>
    stats = {}
    table.insert stats, @name
    table.insert stats, @description
    if @quote
      table.insert stats, @quote
    return stats

  pickup: (player) =>
    table.insert player.equipped_items, @
    @collectable = false
    @contact_damage = false
    @solid = false
    @player = player
    --print "Equipped " .. @name

  unequip: (player) =>
    successful = false
    for k, i in pairs player.equipped_items
      if i.name == @name
        table.remove player.equipped_items, k
        successful = true
        break
    --if successful
    --  print "Unequipped " .. @name
    --else
    --  print "Couldn't unequip " .. @name

  onKill: (entity) =>
    return

  use: =>
    return

  update2: (dt) =>
    @timer += dt

  update: (dt) =>
    if @collectable
      super dt
    else
      @update2 dt

  draw2: =>
    return

  draw: =>
    if @collectable
      super!
    else
      @draw2!
