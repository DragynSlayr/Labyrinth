export class PauseScreen extends Screen
  new: =>
    super!
    @font = Renderer\newFont 20
    @sprites = {(Sprite "player/test.tga", 16, 16, 2, 50 / 16)}
    @icons = {
      (Sprite "ui/icons/health.tga", 16, 16, 1, 1),
      (Sprite "ui/icons/range.tga", 16, 16, 1, 1),
      (Sprite "ui/icons/damage.tga", 16, 16, 1, 1),
      (Sprite "ui/icons/speed.tga", 16, 16, 1, 1),
      (Sprite "ui/icons/attack_delay.tga", 16, 16, 1, 1)
    }
    @player_icons = @icons

    @item_grid = ItemGrid!

    @lower_draw = 1
    @higher_draw = 5

    @layer_idx = 0
    @current_layer = 0

    @getControls!

  nextLayer: =>
    if @current_layer < @layer_idx
      @lower_draw += 5
      @higher_draw += 5
      @current_layer += 1

  previousLayer: =>
    if @current_layer > 0
      @lower_draw -= 5
      @higher_draw -= 5
      @current_layer -= 1

  getControls: =>
    export KEY_CHANGED = false
    @move_controls = {}
    @shoot_controls = {}
    @other_controls = {}
    for k, v in pairs Controls.key_names
      key = Controls.keys[v]
      value = (toTitle v, "_") .. " : " .. key
      if startsWith v, "MOVE"
        table.insert @move_controls, value
      elseif startsWith v, "SHOOT"
        table.insert @shoot_controls, value
      else
        table.insert @other_controls, value
    @controls = {@move_controls, @other_controls, @shoot_controls}

  update: (dt) =>
    typeof = ItemFrame
    frames = UI\filter typeof, Screen_State.inventory
    frames2 = UI\filter typeof
    for k, v in pairs frames2
      if frames[k].item.__class ~= v.item.__class
        v\setItem frames[k].item
        v.sprite\setScale 2.5
        v.small_sprite = v.sprite
        v.normal_sprite = v.small_sprite
    if KEY_CHANGED
      @getControls!
    @layer_idx = math.floor (#@item_grid.items / 5)
    for k, frame in pairs @item_grid.items
      if k >= @lower_draw and k <= @higher_draw
        frame\update dt

  draw: =>
    Camera\unset!

    width = 510
    height = 210
    x = Screen_Size.half_width - (width / 2)
    y = (Screen_Size.half_height + 70) - (height / 2)
    setColor 0, 0, 0, 200
    love.graphics.rectangle "fill", x, y, width, height, 10, 10
    love.graphics.setLineWidth 3
    setColor 150, 150, 150, 255
    love.graphics.rectangle "line", x, y, width, height, 10, 10
    love.graphics.setLineWidth 1

    Camera\set!
  --   Camera\unset!
  --   stats = {}
  --   for j = 1, 1
  --     y = Screen_Size.height * 0.4
  --     stats = MainPlayer\getStats!
  --     x = Screen_Size.width * 0.05
  --     icons = @player_icons
  --     bounds = @sprites[j]\getBounds x, y
  --     for i = 1, #stats
  --       y = map i, 1, #stats, (Screen_Size.height * 0.4) + (40 * Scale.height), Screen_Size.height * 0.60
  --       Camera\unset!
  --       icons[i]\draw x, y + (9 * Scale.height)
  --       Camera\set!
  --       Renderer\drawHUDMessage (string.format "%.2f", stats[i]), x + (10 * Scale.width) + bounds.radius, y, @font
  --
  --   -- Draw controls
  --   Camera\unset!
  --   love.graphics.setFont (Renderer\newFont 20)
  --   setColor 0, 0, 0, 255
  --   for i = 1, 3
  --     y = 0.04
  --     if i == 2
  --       y /= 2
  --     for k, v in pairs @controls[i]
  --       love.graphics.printf v, (Screen_Size.width / 3) * (i - 1), Screen_Size.height * y, Screen_Size.width / 3, "center"
  --       y += 0.055
  --   Camera\set!
  --
  --   -- Draw item frames, TODO: Remove this later?
  --   love.graphics.setFont (Renderer\newFont 30)
  --   setColor 0, 0, 0, 255
  --   Camera\unset!
  --   love.graphics.printf (@current_layer + 1) .. " / " .. (@layer_idx + 1), 0, Screen_Size.height * 0.74, Screen_Size.width, "center"
  --   Camera\set!
  --   for k, frame in pairs @item_grid.items
  --     if k >= @lower_draw and k <= @higher_draw
  --       x = ((Screen_Size.width / (@higher_draw - @lower_draw + 2)) * ((k - @lower_draw) + 1))
  --       old_x, old_y, old_center = frame.x, frame.y, frame.center
  --       frame.x = x - (frame.width / 2)
  --       frame.y = Screen_Size.height * 0.8
  --       frame.center = Point frame.x + (frame.width / 2), frame.y + (frame.width / 2)
  --       frame\draw!
  --       frame.x, frame.y, frame.center = old_x, old_y, old_center
  --       x += 100
  --   Camera\set!
