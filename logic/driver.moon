export class Driver
    setBindings: =>
      love.keypressed = @keypressed
      love.keyreleased = @keyreleased
      love.mousepressed = @mousepressed
      love.mousereleased = @mousereleased
      love.wheelmoved = @wheelmoved
      love.textinput = @textinput
      love.focus = @focus
      love.update = @update
      love.draw = @draw

    writeDefaultSettings: =>
      defaults = {}
      defaults[1]  = {"MODS_ENABLED", 0}
      defaults[2]  = {"FILES_DUMPED", 0}
      defaults[3]  = {"FULLSCREEN", 1}
      defaults[4]  = {"WIDTH", love.graphics.getWidth!}
      defaults[5]  = {"HEIGHT", love.graphics.getHeight!}
      defaults[6]  = {"VSYNC", 0}
      defaults[7]  = {"SHOW_FPS", 0}
      defaults[8]  = {"MOVE_UP", "w"}
      defaults[9]  = {"MOVE_DOWN", "s"}
      defaults[10] = {"MOVE_LEFT", "a"}
      defaults[11] = {"MOVE_RIGHT", "d"}
      defaults[12] = {"USE_ITEM", "q"}
      defaults[13] = {"PAUSE_GAME", "escape"}
      defaults[14] = {"SHOW_RANGE", "z"}
      defaults[15] = {"OPEN_INVENTORY", "i"}
      defaults[16] = {"OPEN_LEVEL_UP", "l"}

      newSettings = ""
      if love.filesystem.getInfo "SETTINGS"
        for i = 1, #defaults
          k = defaults[i][1]
          val = readKey k
          if val
            defaults[i] = {k, val}
      for i = 1, #defaults
        newSettings ..= defaults[i][1] .. " " .. defaults[i][2] .. "\n"

      love.filesystem.write "SETTINGS", newSettings

    checkMods: =>
      if MODS_ENABLED and not FILES_DUMPED
        print "DUMPING FILES"

        dirs = getAllDirectories "assets"
        for k, v in pairs dirs
          love.filesystem.createDirectory "mods/" .. v

        files = getAllFiles "assets"
        for k, v in pairs files
          if not love.filesystem.getInfo ("mods/" .. v)
            print "DUMPING " .. v
            contents, size = love.filesystem.read v
            love.filesystem.write "mods/" .. v, contents

        print "FILES DUMPED"
        writeKey "FILES_DUMPED", "1"

      if MODS_ENABLED
        export PATH_PREFIX = "mods/"
      else
        export PATH_PREFIX = ""

    fixScreenSettings: =>
      flags = {}
      flags.fullscreen = (readKey "FULLSCREEN") == "1"
      flags.vsync = (readKey "VSYNC") == "1"
      width = tonumber (readKey "WIDTH")
      height = tonumber (readKey "HEIGHT")

      current_width, current_height, current_flags = love.window.getMode!

      num_diff = 0
      if flags.fullscreen ~= current_flags.fullscreen
        num_diff += 1
      if flags.vsync ~= current_flags.vsync
        num_diff += 1
      if width ~= current_width
        num_diff += 1
      if height ~= current_height
        num_diff += 1

      if num_diff > 0
        love.window.setMode width, height, flags

      calcScreen!

    new: =>
      @setBindings!

      love.filesystem.setIdentity "Labyrinth"
      love.filesystem.createDirectory "screenshots"

      @writeDefaultSettings!

      MODS_ENABLED = (readKey "MODS_ENABLED") == "1"
      FILES_DUMPED = (readKey "FILES_DUMPED") == "1"

      @checkMods!

      export SHOW_FPS = (readKey "SHOW_FPS") == "1"

      @fixScreenSettings!

      export KEY_CHANGED = true

      --export KEY_PUSHED = false

    spawn: (typeof, layer, x = (math.random Screen_Size.width), y = (math.random Screen_Size.height), i = 0) ->
      enemy = typeof x, y
      touching = false
      for k, o in pairs layer.objects
        object = o\getHitBox!
        e = enemy\getHitBox!
        if object\contains e
          --touching = true
          break
      if touching --or not enemy\isOnScreen Screen_Size.border
        layer\remove enemy
        Driver.spawn typeof, layer, x, y, i + 1
      else
        return enemy

    killEnemies: =>
      EnemyHandler\clear!
      BulletHandler\clear!

    getRandomPosition: =>
      x = math.random Screen_Size.border[1], Screen_Size.border[3]
      y = math.random Screen_Size.border[2], Screen_Size.border[4]
      return Point x, y

    quitGame: ->
      ScoreTracker\disconnect!
      ScoreTracker\saveScores!
      love.event.quit 0

    keypressed: (key, scancode, isrepeat) ->
      --export KEY_PUSHED = true
      if key == "printscreen"
        screenshot = love.graphics.captureScreenshot ("screenshots/" .. os.time! .. ".png")

      if DEBUG_MENU
        if DEBUG_MENU_ENABLED
          if key == "`"
            export DEBUG_MENU = false
          else
            Debugger\keypressed key, scancode, isrepeat
      else
        if key == "`"
          if DEBUG_MENU_ENABLED
            export DEBUG_MENU = true
        elseif key == Controls.keys.PAUSE_GAME
          if Driver.game_state ~= Game_State.game_over
            if Driver.game_state == Game_State.paused
              Driver.unpause!
            else
              Driver.pause!
        else
          UI\keypressed key, scancode, isrepeat
          switch Driver.game_state
            when Game_State.playing
              MainPlayer\keypressed key
            when Game_State.game_over
              GameOver\keypressed key, scancode, isrepeat

    keyreleased: (key) ->
      --pushed = false
      --for k, v in pairs Controls.keys
      --  print k, v
      --  if love.keyboard.isDown v
      --    pushed = true
      --    break
      --export KEY_PUSHED = pushed
      if DEBUG_MENU
        Debugger\keyreleased key
      else
        UI\keyreleased key
        switch Driver.game_state
          when Game_State.playing
            MainPlayer\keyreleased key
          when Game_State.game_over
            GameOver\keyreleased key
          when Game_State.controls
            Controls\keyreleased key

    mousepressed: (x, y, button, isTouch) ->
      if DEBUG_MENU
        Debugger\mousepressed x, y, button, isTouch
      else
        UI\mousepressed x, y, button, isTouch
        switch Driver.game_state
          when Game_State.playing
            if Driver.dialog.enabled
              Driver.dialog\mousepressed x, y, button, isTouch
            else
              if not (NPCHandler\mousepressed x, y, button, isTouch)
                MainPlayer\mousepressed x, y, button, isTouch
          when Game_State.game_over
            GameOver\mousepressed x, y, button, isTouch

    mousereleased: (x, y, button, isTouch) ->
      if DEBUG_MENU
        Debugger\mousereleased x, y, button, isTouch
      else
        UI\mousereleased x, y, button, isTouch
        switch Driver.game_state
          when Game_State.playing
            if Driver.dialog.enabled
              Driver.dialog\mousereleased x, y, button, isTouch
            else
              if not (NPCHandler\mousereleased x, y, button, isTouch)
                MainPlayer\mousereleased x, y, button, isTouch
          when Game_State.game_over
            GameOver\mousereleased x, y, button, isTouch

    wheelmoved: (x, y) ->
      if Driver.game_state == Game_State.playing
        MainPlayer\wheelmoved x, y

    textinput: (text) ->
      if DEBUG_MENU
        Debugger\textinput text
      else
        UI\textinput text
        switch Driver.game_state
          when Game_State.game_over
            GameOver\textinput text

    focus: (focus) ->
      if focus
        Driver.unpause!
      else
        Driver.pause!
      UI\focus focus

    pause: ->
      Driver.state_stack\add Driver.game_state
      Driver.game_state = Game_State.paused
      MainPlayer.keys_pushed = 0
      UI.state_stack\add UI.current_screen
      UI\set_screen Screen_State.pause_menu

    unpause: ->
      Driver.game_state = Driver.state_stack\remove!
      UI\set_screen UI.state_stack\remove!

    game_over: ->
      Driver.game_state = Game_State.game_over
      UI\set_screen Screen_State.game_over

    exportVars: =>
      export ScoreTracker = Score!
      export MusicPlayer = MusicHandler!
      export Camera = CameraHandler!
      export Renderer = ObjectRenderer!
      export UI = UIHandler!
      export Debugger = DebugMenu!
      export Collision = CollisionChecker!
      export ItemPool = ItemPoolHandler!
      export Controls = ControlsHandler!
      export Pause = PauseScreen!
      export GameOver = GameOverScreen!
      --export Levels = LevelHandler!
      export BackgroundHandler = Handler!
      export ParticleHandler = Handler!
      export BulletHandler = Handler!
      export EnemyHandler = Handler!
      export TimerHandler = Handler!
      export BossHandler = Handler!
      export WallHandler = Handler!
      export NPCHandler = Handler!
      export World = WorldHandler!

    intializeDriverVars: =>
      Driver.game_state = Game_State.none
      Driver.state_stack = Stack!
      Driver.state_stack\add Game_State.main_menu
      Driver.elapsed = 0
      Driver.shader = nil

    restart: =>
      -- Set love environment
      love.graphics.setDefaultFilter "nearest", "nearest", 1

      @intializeDriverVars!

      @exportVars!

      ScreenCreator!

      -- Create a player
      export MainPlayer = Player 1586, 2350
      MainPlayer\pickClass 0
      MainPlayer\updateStats true

      -- positions = {
      --   (Vector 450, 2340),
      --   (Vector 350, 2230),
      --   (Vector 450, 2080)
      -- }
      -- for i = 1, 3
      --   item = ItemPool\getItem!
      --   vec = positions[i]
      --   ped = ItemPedestal vec.x, vec.y, item, item.rarity * 10
      --   ped.refilling = true

      -- y = 1600
      -- for i = 1, 10
      --   coin = Coin 1650, y, (i * 2)
      --   y += 75

      timer = Timer 1, @, (() =>
        if @questing
          Driver.spawn (BasicEnemy), EnemyHandler
      ), true

      love.mouse.setVisible false

      @cursor_sprite = Sprite "ui/crosshair.tga", 24, 24, 1, 1.5
      @cursor_sprite\setRotationSpeed (math.pi / 2)

      item = BlackHoleActive 5
      ped = ItemPedestal 1586, 2200, item

      @dialog = Dialog!

      text = {"Hello, welcome to the starting area of this game, click to continue", "Would you like to take a quest?", "Nice, too bad I don't have one", "Come back later then"}
      npc = NPC 2680, 2000, "Ted", text

      npc\setPath {
        {(Vector 100, 0), 2.5},
        {(Vector 0, 100), 3},
        {(Vector -100, 0), 2.5},
        {(Vector 0, -100), 3}
      }

      npc\addButton 2, "Yes", (parent) ->
        parent\goToNext!
      npc\addButton 2, "No", (parent) ->
        parent\goToNext!
        parent\goToNext!

      npc\addButton 3, "Bye", (parent) ->
        parent\goToNext!
        parent\goToNext!

      npc\addButton 4, "Bye", (parent) ->
        parent\goToNext!
        timer.questing = true

      -- Start game
      --Levels\nextLevel!

    updateHandlers: (dt) ->
      TimerHandler\update dt
      WallHandler\update dt
      BackgroundHandler\update dt
      ParticleHandler\update dt
      BulletHandler\update dt
      BossHandler\update dt
      EnemyHandler\update dt
      MainPlayer\update dt
      if MainPlayer.health <= 0 or not MainPlayer.alive
        MainPlayer\kill!
      NPCHandler\update dt
      Collision\update dt
      -- Levels\update dt
      World\update dt
      MainPlayer\postUpdate dt

    update: (dt) ->
      Driver.cursor_sprite\update dt
      --if not KEY_PUSHED
      --  return
      if DEBUG_MENU
        Debugger\update dt
      else
        Driver.elapsed += dt
        switch Driver.game_state
          when Game_State.game_over
            GameOver\update dt
          when Game_State.paused
            Pause\update dt
          when Game_State.controls
            Controls\update dt
          when Game_State.playing
            if Driver.dialog.enabled
              Driver.dialog\update dt
              World\update dt
              MainPlayer\postUpdate dt
            else
              Driver.updateHandlers dt
        UI\update dt
        ScoreTracker\update dt

        if not Driver.shader
          Driver.shader = love.graphics.newShader "shaders/normal.fs"

    drawBackground: ->
      if Driver.game_state == Game_State.playing or UI.current_screen == Screen_State.none
        love.graphics.setShader Driver.shader
      Camera\unset!
      if Driver.game_state == Game_State.playing or (Driver.game_state == Game_State.paused and Driver.state_stack\peekLast! == Game_State.playing)
        setColor 106, 190, 48, 255
      else
        setColor 121, 128, 134, 255
      love.graphics.rectangle "fill", 0, 0, Screen_Size.width, Screen_Size.height
      Camera\set!
      if Driver.game_state == Game_State.playing or UI.current_screen == Screen_State.none
        love.graphics.setShader!

    drawDebugInfo: ->
      if DEBUGGING
        y = 100
        font = Renderer\newFont 20
        white_color = Color 255, 255, 255
        handlers = {
          BackgroundHandler, ParticleHandler, BulletHandler, EnemyHandler,
          TimerHandler, BossHandler, WallHandler, NPCHandler
        }
        names = {
          "Backgrounds", "Particles", "Bullets", "Enemies", "Timers",
          "Bosses", "Walls", "NPCs"
        }
        for k, handler in pairs handlers
          message = names[k] .. ": " .. #handler.objects
          Renderer\drawAlignedMessage message, y, "left", font, white_color
          y += 25

        format = (x) -> return string.format "%.0f", x
        camera_pos = format(Camera.position.x - Screen_Size.half_width) .. ", " .. format(Camera.position.y - Screen_Size.half_height)
        Renderer\drawAlignedMessage ("Camera: " .. camera_pos), y, "left", font, white_color
        y += 25
        Renderer\drawAlignedMessage "Timers: " .. #TimerHandler.objects, y, "left", font, white_color

        cursor_x, cursor_y = love.mouse.getPosition!
        cursor_pos = format(cursor_x + Camera.position.x - Screen_Size.width) .. ", " .. format(cursor_y + Camera.position.y - Screen_Size.height)
        Renderer\drawAlignedMessage ("Cursor: " .. cursor_pos), y + 25, "left", font, white_color

    drawMoney: ->
      Camera\unset!
      font = Renderer\newFont 30
      love.graphics.setFont font
      setColor 255, 215, 0, 255
      love.graphics.printf ("$ " .. MainPlayer.coins), 0, (20 * Scale.width) - (font\getHeight! / 2), Screen_Size.width - (10 * Scale.width), "right"
      Camera\set!

    drawPlaying: ->
      World\draw!
      --Levels\draw!
      Renderer\drawAll!
      Driver.drawMoney!
      Driver.drawDebugInfo!
      Driver.dialog\draw!

    draw: ->
      Camera\set!
      Driver.drawBackground!
      UI\draw!
      switch Driver.game_state
        when Game_State.playing
          Driver.drawPlaying!
        when Game_State.controls
          Controls\draw!
        when Game_State.paused
          if Driver.state_stack\peekLast! == Game_State.playing
            Driver.drawPlaying!
            setColor 50, 50, 50, 127
            Camera\unset!
            love.graphics.rectangle "fill", 0, 0, Screen_Size.width, Screen_Size.height
            Camera\set!
          Pause\draw!
          UI\draw!
        when Game_State.game_over
          GameOver\draw!

      Camera\unset!
      setColor 0, 0, 0, 127
      love.graphics.setFont (Renderer\newFont 20)
      love.graphics.printf VERSION, 0, Screen_Size.height - (25 * Scale.height), Screen_Size.width - (10 * Scale.width), "right"
      if SHOW_FPS
        love.graphics.printf love.timer.getFPS! .. " FPS", 0, Screen_Size.height - (50 * Scale.height), Screen_Size.width - (10 * Scale.width), "right"
      Camera\set!

      if DEBUG_MENU
        Debugger\draw!

      Camera\unset!

      x, y = love.mouse.getPosition!
      Driver.cursor_sprite\draw x, y

      collectgarbage "step"
