export class ItemGrid extends UIElement
  new: (x, y) =>
    super x, y

    @items = {}
    @max_cols = 5
    @max_rows = 3
    @row_idx = 0
    @col_idx = 0
    @layer_idx = 0
    @current_layer = 0
    @box_size = 150
    @spacing = 10

  addItem: (item) =>
    for k, v in pairs @items
      if item.name == v.item.name
        if item.rarity > v.item.rarity
          v.item\unequip MainPlayer
          new_item = ItemFrame v.x + (v.width / 2), v.y + (v.width / 2), item
          new_item.draw_layer = v.draw_layer
          new_item.usable = false
          @items[k] = new_item
          item\pickup MainPlayer
        return
    length = #@items
    x = @x + (@col_idx * ((@box_size + @spacing) * Scale.width))
    y = @y + (@row_idx * ((@box_size + @spacing) * Scale.height))
    new_item = ItemFrame x, y, item
    new_item.draw_layer = @layer_idx
    new_item.usable = false
    table.insert @items, new_item
    @col_idx += 1
    if @col_idx >= @max_cols
      @col_idx = 0
      @row_idx += 1
      if @row_idx >= @max_rows
        @col_idx = 0
        @row_idx = 0
        @layer_idx += 1
    item\pickup MainPlayer

  nextLayer: =>
    if @current_layer + 1 <= @layer_idx
      @current_layer += 1

  previousLayer: =>
    if @current_layer - 1 >= 0
      @current_layer -= 1

  update: (dt) =>
    for k, v in pairs @items
      if v.draw_layer == @current_layer
        v\update dt

  draw: =>
    for k, v in pairs @items
      if v.draw_layer == @current_layer
        v\draw!
    Camera\unset!
    love.graphics.setFont (Renderer\newFont 30)
    setColor 0, 0, 0, 255
    love.graphics.printf (@current_layer + 1) .. " / " .. (@layer_idx + 1), Screen_Size.width * 0.8, Screen_Size.height * 0.58, Screen_Size.width * 0.2, "center"
    Camera\set!
