-- Class for rendering GameObjects and text
export class ObjectRenderer
  new: =>
    -- Initialize queue and cache
    @queue = {}
    @font_cache = {}

  newFont: (size) =>
    size = math.floor (size * Scale.diag)
    if not @font_cache[size]
      @font_cache[size] = love.graphics.newFont PATH_PREFIX .. "assets/fonts/lm-r.ttf", size
    return @font_cache[size]

  -- Adds a drawing function to the queue
  -- func: The drawing function
  enqueue: (func) =>
    -- Add the function to the queue
    @queue[#@queue + 1] = func

  -- Draw everything in the layers
  drawAll: =>
    WallHandler\draw!
    BackgroundHandler\draw!
    ParticleHandler\draw!
    BulletHandler\draw!

    -- Draw each GameObject in the layers
    for k, layer in pairs EntityTypes.order
      for i, object in pairs Driver.objects[layer]
        if object.draw
          object\draw!

    NPCHandler\draw!

    -- Call each function in the queue
    for k, func in pairs @queue
      func!

    -- Clear queue
    @queue = {}

  -- Draws a HUD (large) message
  -- message: The message
  -- x: X location of the message
  -- y: Y location of the message
  -- font: The font to use
  drawHUDMessage: (message, x, y, font = (Renderer\newFont 30), color = Color!) =>
    Camera\unset!

    -- Clear shader
    love.graphics.setShader!

    -- Apply new transforms
    setColor color\get!
    love.graphics.setFont font

    -- Display the message
    love.graphics.print message, x, y

    Camera\set!

  -- Draws a status (centered) message
  -- message: The message
  -- y: Y location of the message
  -- font: The font to use
  drawStatusMessage: (message, y = 0, font = (Renderer\newFont 20), color = Color!) =>
    -- Draw text in the center of the screen
    @drawAlignedMessage message, y, "center", font, color

  drawAlignedMessage: (message, y, alignment = "center", font = (Renderer\newFont 20), color = Color!) =>
    Camera\unset!

    -- Clear shader
    love.graphics.setShader!

    -- Apply new transforms
    setColor color\get!
    love.graphics.setFont font

    -- Draw an aligned message to the screen
    love.graphics.printf message, 0, y - (font\getHeight! / 2), love.graphics\getWidth!, alignment

    Camera\set!
