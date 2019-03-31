-- Class for representing and drawing a Sprite
export class Sprite

  -- name: The path to the image file
  -- height: The height of the image
  -- width: The width of the image
  -- delay: The length of an animation cycle for this Sprite
  -- scale: How much to scale this Sprite by
  new: (name, height, width = height, delay = 1.0, scale = 1.0) =>
    @name = name
    @props = {height, width, delay, scale}

    path = "assets/sprites/" .. name
    if love.filesystem.getInfo (PATH_PREFIX .. path)
      path = PATH_PREFIX .. path

    -- Load the image
    @image = ResoureLoader\loadImage path

    -- Get number of frames
    @frames = @image\getWidth! / width

    -- Assign height and width
    @height, @width = height, width

    -- Scale image
    @x_scale, @y_scale = scale * Scale.diag, scale * Scale.diag
    @scaled_width, @scaled_height = @width * @x_scale, @height * @y_scale

    -- Load all images of this Sprite's animation
    @sprites = {}
    for i = 0, @frames - 1
      @sprites[i + 1] = love.graphics.newQuad i * @width, 0, @width, @height, @image\getDimensions!

    -- Variables for animation timings
    @time = 0
    @max_time = delay / @frames
    @current_frame = 1

    -- Variables for handling rotation
    @rotation = 0
    @rotation_speed = 0

    @color = {255, 255, 255, 255}

    @x_shear = 0
    @y_shear = 0

  getCopy: =>
    sprite = Sprite @name, @getProperties!
    sprite.color = {@color[1], @color[2], @color[3], @color[4]}
    sprite.rotation_speed = @rotation_speed
    sprite.rotation = @rotation
    sprite.x_shear = @x_shear
    sprite.y_shear = @y_shear
    x_scale = @scaled_width / (@width * Scale.width)
    y_scale = @scaled_height / (@height * Scale.height)
    sprite\setScale x_scale, y_scale
    if @shader
      sprite\setShader @shader
    return sprite

  getProperties: () =>
    return @props[1], @props[2], @props[3], @props[4]

  setCurve: (curve) =>
    @curve = curve
    @hasCurve = true

  -- Set the color of the Sprite
  -- color: The color of the Sprite
  setColor: (color) =>
    -- Set the color
    @color = color

  setShear: (x_shear, y_shear) =>
    @x_shear = x_shear
    @y_shear = y_shear

  -- Resize the Sprite
  -- x: The new x scale
  -- y: The new y scale
  setScale: (x, y = x) =>
    -- Set scale
    @x_scale = x * Scale.width
    @y_scale = y * Scale.height

    -- Recalculate scaled height and width
    @scaled_width = @width * @x_scale
    @scaled_height = @height * @y_scale

  scaleUniformly: (scale) =>
    x_scale = @scaled_width / (@width * Scale.width)
    y_scale = @scaled_height / (@height * Scale.height)
    @setScale x_scale * scale, y_scale * scale

  -- Set the speed of rotation of this Sprite
  -- speed: The new rotation speed
  setRotationSpeed: (speed) =>
    -- Set the rotation speed
    @rotation_speed = speed

  -- Set the rotation of this Sprite
  -- angle: The new rotation of this Sprite
  setRotation: (angle) =>
    -- Set the rotation of the Sprite
    @rotation = angle

  setShader: (shader) =>
    @shader = shader
    @has_shader = true
    @should_shade = true

  -- Get the bounding circle of this Sprite
  -- x: The x position of this Sprite
  -- y: The y position of this Sprite
  getBounds: (x, y) =>
    -- Get the radius of this Sprite as the minimum of height and width
    radius = math.min @scaled_height / 2, @scaled_width / 2

    -- Return a new Circle at this x and y with the radius
    return Circle x, y, radius

  -- Update this Sprite
  -- dt: The time since the last update
  update: (dt) =>
    -- Update rotation
    @rotation += (math.pi * dt * @rotation_speed)

    -- Increment time
    @time += dt

    if @hasCurve
      @max_time = @curve[@current_frame]

    -- Check if new frame should be loaded
    if @time >= @max_time
      -- Reset time
      @time = 0

      -- Go to the next frame
      if @current_frame == @frames
        @current_frame = 1
      else
        @current_frame += 1

  -- Draw this Sprite
  -- x: X location of position to draw at
  -- y: Y location of position to draw at
  draw: (x, y) =>
    -- Store previous transforms
    love.graphics.push "all"

    if Driver.game_state == Game_State.playing or UI.current_screen == Screen_State.none
      if @has_shader and @should_shade
        love.graphics.setShader @shader
      else
        love.graphics.setShader Driver.shader

    -- Color sprite
    setColor @color[1], @color[2], @color[3], @color[4]

    -- Draw the sprite
    love.graphics.draw @image, @sprites[@current_frame], math.floor(x), math.floor(y), @rotation, @x_scale, @y_scale, @width / 2, @height / 2, @x_shear, @y_shear

    -- Restore previous transforms
    if Driver.game_state == Game_State.playing or UI.current_screen == Screen_State.none
      love.graphics.setShader!
    love.graphics.pop!
