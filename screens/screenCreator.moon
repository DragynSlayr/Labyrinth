export class ScreenCreator
  new: =>
    @createControlsMenu!
    @createSettingsMenu!
    @createGameOverMenu!
    @createPauseMenu!
    @createMainMenu!

  createControlsMenu: =>
    UI\set_screen Screen_State.controls

    y = 0.1
    for k, v in pairs Controls.key_names
      key = split v, "_"
      key = toTitle (key[1] .. " " .. key[2])
      UI\add (Text Screen_Size.width * 0.45, Screen_Size.height * y, key, (Renderer\newFont 20))
      b = Button Screen_Size.width * 0.55, Screen_Size.height * y, 125, 35, Controls.keys[v], nil, (Renderer\newFont 20)
      b.action = (() ->
        Controls.selected = k
        Controls.button = b
        Controls.selected_text = key
      )
      UI\add b
      y += 0.055

    back_button = Button Screen_Size.width / 2, Screen_Size.height - (34 * Scale.height), 250, 60, "Back", () ->
      Driver.game_state = Game_State.settings
      UI\set_screen Screen_State.settings
    UI\add back_button

  createSettingsMenu: =>
    UI\set_screen Screen_State.settings

    _, _, current_flags = love.window.getMode!

    controls_button = Button Screen_Size.width / 2, Screen_Size.height - (162 * Scale.height), 250, 60, "Controls", () ->
      Driver.game_state = Game_State.controls
      UI\set_screen Screen_State.controls
    UI\add controls_button

    UI\add (Text Screen_Size.width * 0.45, Screen_Size.height * 0.255, "Fullscreen", (Renderer\newFont 20))
    fs_cb = CheckBox Screen_Size.width * 0.55, Screen_Size.height * 0.255, 50, nil
    fs_cb.checked = love.window.getFullscreen!
    UI\add fs_cb

    UI\add (Text Screen_Size.width * 0.45, Screen_Size.height * 0.31, "Vertical Sync", (Renderer\newFont 20))
    vs_cb = CheckBox Screen_Size.width * 0.55, Screen_Size.height * 0.31, 50, nil
    vs_cb.checked = current_flags.vsync
    UI\add vs_cb

    UI\add (Text Screen_Size.width * 0.45, Screen_Size.height * 0.365, "Show FPS", (Renderer\newFont 20))
    fps_cb = CheckBox Screen_Size.width * 0.55, Screen_Size.height * 0.365, 50, nil
    fps_cb.checked = SHOW_FPS
    UI\add fps_cb

    UI\add (Text Screen_Size.width * 0.45, Screen_Size.height * 0.41, "Resolution", (Renderer\newFont 20))
    resolutions = {
      "1920 x 1080",
      "1600 x 900",
      "1366 x 768",
      "1280 x 1024",
      "1024 x 768",
      "800 x 600"
    }
    current_res = Screen_Size.width .. " x " .. Screen_Size.height
    if not (tableContains resolutions, current_res)
      table.insert resolutions, current_res
      table.sort resolutions, (a, b) ->
        return (tonumber (split a, " ")[1]) > (tonumber (split b, " ")[1])
    res_cb = ComboBox Screen_Size.width * 0.55, Screen_Size.height * 0.41, 125, 35, resolutions, (Renderer\newFont 20)
    res_cb.text = current_res
    UI\add res_cb

    apply_button = Button Screen_Size.width / 2, Screen_Size.height - (98 * Scale.height), 250, 60, "Apply", () ->
      new_res = split res_cb.text, " "
      new_width = tonumber new_res[1]
      new_height = tonumber new_res[3]

      res_changed = new_width ~= Screen_Size.width or new_height ~= Screen_Size.height

      flags = {}
      flags.fullscreen = fs_cb.checked and not res_changed
      flags.vsync = vs_cb.checked

      current_width, current_height, current_flags = love.window.getMode!

      num_diff = 0
      if flags.fullscreen ~= current_flags.fullscreen
        num_diff += 1
      if flags.vsync ~= current_flags.vsync
        num_diff += 1
      if new_width ~= current_width
        num_diff += 1
      if new_height ~= current_height
        num_diff += 1

      if num_diff > 0
        love.window.setMode new_width, new_height, flags

      calcScreen!

      export SHOW_FPS = fps_cb.checked

      if fs_cb.checked and not res_changed
        writeKey "FULLSCREEN", "1"
      else
        writeKey "FULLSCREEN", "0"

      writeKey "WIDTH", (tostring new_width)
      writeKey "HEIGHT", (tostring new_height)

      if vs_cb.checked
        writeKey "VSYNC", "1"
      else
        writeKey "VSYNC", "0"

      if fps_cb.checked
        writeKey "SHOW_FPS", "1"
      else
        writeKey "SHOW_FPS", "0"

      Driver\restart!
    UI\add apply_button

    back_button = Button Screen_Size.width / 2, Screen_Size.height - (34 * Scale.height), 250, 60, "Back", () ->
      Driver.game_state = Game_State.none
      UI\set_screen Screen_State.main_menu
    UI\add back_button

  createMainMenu: =>
    UI\set_screen Screen_State.main_menu

    title = Text Screen_Size.width / 2, (Screen_Size.height / 4), "Tower Defense"
    UI\add title

    start_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) - (32 * Scale.height), 250, 60, "Start", () ->
      Driver.game_state = Game_State.playing
      UI\set_screen Screen_State.none
    UI\add start_button

    settings_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + (32 * Scale.height), 250, 60, "Settings", () ->
      Driver.game_state = Game_State.settings
      UI\set_screen Screen_State.settings
    UI\add settings_button

    exit_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + (96 * Scale.height), 250, 60, "Exit", () ->
      Driver.quitGame!
    UI\add exit_button

  createPauseMenu: =>
    UI\set_screen Screen_State.pause_menu

    title = Text Screen_Size.width / 2, (Screen_Size.height / 3), "Game Paused"
    UI\add title

    sprite = Sprite "player/test.tga", 16, 16, 2, 50 / 16
    sprite\setRotationSpeed -math.pi / 2
    x = Screen_Size.width * 0.05--0.20
    y = Screen_Size.height * 0.4
    icon = Icon x, y, sprite
    UI\add icon
    bounds = sprite\getBounds x, y
    font = Renderer\newFont 20
    width = font\getWidth "Player"
    text = Text x + (10 * Scale.width) + bounds.radius + (width / 2), y, "Player", font
    UI\add text

    resume_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) - (32 * Scale.height), 250, 60, "Resume", () ->
      Driver.unpause!
    UI\add resume_button

    restart_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + (32 * Scale.height), 250, 60, "Restart", () ->
      ScoreTracker\saveScores!
      Driver\restart!
    UI\add restart_button

    quit_button = Button Screen_Size.width / 2, (Screen_Size.height / 2) + (96 * Scale.height), 250, 60, "Quit", () ->
      Driver.quitGame!
    UI\add quit_button

    left_button = Button Screen_Size.width * 0.45, (Screen_Size.height * 0.76), 64, 64, "", () ->
      Pause\previousLayer!
    left_button\setSprite (Sprite "ui/button/left_idle.tga", 32, 32, 1, 1), (Sprite "ui/button/left_click.tga", 32, 32, 1, 1)
    UI\add left_button

    right_button = Button Screen_Size.width * 0.55, (Screen_Size.height * 0.76), 64, 64, "", () ->
      Pause\nextLayer!
    right_button\setSprite (Sprite "ui/button/right_idle.tga", 32, 32, 1, 1), (Sprite "ui/button/right_click.tga", 32, 32, 1, 1)
    UI\add right_button

  createGameOverMenu: =>
    UI\set_screen Screen_State.game_over

    title = Text Screen_Size.width / 2, (Renderer\newFont 250)\getHeight! / 2, "GAME OVER", (Renderer\newFont 250)
    UI\add title

    restart_button = Button (Screen_Size.width / 2) - (127.5 * Scale.width), Screen_Size.height - (35 * Scale.height), 250, 60, "Restart", () ->
      ScoreTracker\saveScores!
      Driver\restart!
    UI\add restart_button

    quit_button = Button (Screen_Size.width / 2) + (127.5 * Scale.width), Screen_Size.height - (35 * Scale.height), 250, 60, "Quit", () ->
      Driver.quitGame!
    UI\add quit_button
