-- Class for representing a Button
export class Button extends UIElement

  -- x: X coordinate of the Button
  -- y: Y coordinate of the Button
  -- width: Width of the Button
  -- height: Height of the Button
  -- text: Text to be shown on the Button
  -- action: Function to execute when the Button is clicked
  new: (x, y, width, height, text, action, font = (Renderer\newFont 30)) =>
    super x, y, text, font

    -- Store values
    @width = width * Scale.width
    @height = height * Scale.height
    @action = action

    -- Fix position
    @x -= @width / 2
    @y -= @height / 2

    -- State of the Button
    @idle_color = Color 175, 175, 175
    @hover_color = Color 100, 100, 100
    @selected = false
    @active = true

    idle = Sprite "ui/button/hover.tga", 64, 256, 1, 1
    idle\setScale width / 256, height / 64

    hover = Sprite "ui/button/click.tga", 64, 256, 1, 1
    hover\setScale width / 256, height / 64

    @setSprite idle, hover

  -- Set the color for the Button
  -- idle: Color for when the Button is not hovered over
  -- hover: Color for when the Button is hovered over
  setColor: (idle, hover) =>
    @idle_color = idle
    @hover_color = hover

  -- Set the Sprites for the button
  -- idle: Idle sprite of the Button
  -- hover: Sprite for when the Button is hovered over
  setSprite: (idle, hover) =>
    @idle_sprite = idle
    @hover_sprite = hover
    @sprited = true

  autoResize: (max_width, max_height, x_border = 20, y_border = x_border) =>
    width = @font\getWidth @text
    @width = math.min width + x_border, max_width
    height = @font\getHeight!
    @height = math.min height + y_border, max_height

  -- Checks if a Point is in the Button
  -- x: X coordinate of the Point
  -- y: Y coordinate of the Point
  isHovering: (x, y) =>
    xOn = @x <= x and @x + @width >= x
    yOn = @y <= y and @y + @height >= y
    return xOn and yOn

  mousepressed: (x, y, button, isTouch) =>
    if @active
      if button == 1
        @selected = @isHovering x, y

  mousereleased: (x, y, button, isTouch) =>
    if @active
      if button == 1
        selected = @isHovering x, y
        if selected and @selected
          @action!
          @elapsed = 0
        @selected = false

  -- Update state of the Button
  -- dt: Time since last update
  update: (dt) =>
    -- Update sprites if there are any
    if @sprited
      @idle_sprite\update dt
      @hover_sprite\update dt

  -- Draw the Button
  draw: =>
    Camera\unset!
    if @active
      if @sprited
        -- Draw sprites
        if @selected
          @hover_sprite\draw @x + (@width / 2), @y + (@height / 2)
        else
          @idle_sprite\draw @x + (@width / 2), @y + (@height / 2)
      else
        -- Draw colored box
        if @selected
          setColor @hover_color\get!
        else
          setColor @idle_color\get!
        love.graphics.rectangle "fill", @x, @y, @width, @height
    else
      setColor 127, 127, 127, 255
      love.graphics.rectangle "fill", @x, @y, @width, @height

    -- Draw centered text
    love.graphics.setFont @font
    setColor 0, 0, 0, 255
    if @font_color
      setColor @font_color\get!
    height = @font\getHeight!
    love.graphics.printf @text, @x, @y + ((@height - height) / 2), @width, "center"

    Camera\set!
