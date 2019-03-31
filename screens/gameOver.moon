export class GameOverScreen extends Screen
  new: =>
    @ui_objects = {}
    @createMenu!

  createMenu: =>
    x = (Screen_Size.width / 2) - (250 * Scale.width)
    y = Screen_Size.height - (120 * Scale.height)
    width = 370 * Scale.width
    height = 50 * Scale.height
    submit_box = TextBox x, y, width, height
    submit_box.action = {}
    submit_box.active = false
    submit_box.font = Renderer\newFont 25
    submit_box.text_color = {255, 255, 255, 255}
    @add submit_box

    x = (Screen_Size.width / 2) + (190 * Scale.width)
    y = Screen_Size.height - (95 * Scale.height)
    submit_button = Button x, y, 125, 50, "Submit", () =>
      @active = false
      ScoreTracker\submitScore submit_box\getText!
      submit_box\resetText!
    @add submit_button

  add: (object) =>
    table.insert @ui_objects, object

  keypressed: (key, scancode, isrepeat) =>
    for k, v in pairs @ui_objects
      v\keypressed key, scancode, isrepeat

  keyreleased: (key) =>
    for k, v in pairs @ui_objects
      v\keyreleased key

  mousepressed: (x, y, button, isTouch) =>
    for k, v in pairs @ui_objects
      v\mousepressed x, y, button, isTouch

  mousereleased: (x, y, button, isTouch) =>
    for k, v in pairs @ui_objects
      v\mousereleased x, y, button, isTouch

  textinput: (text) =>
    for k, v in pairs @ui_objects
      v\textinput text

  update: (dt) =>
    for k, v in pairs @ui_objects
      v\update dt

  draw: =>
    for k, v in pairs @ui_objects
      v\draw!

    love.graphics.push "all"

    font = Renderer\newFont 30
    num_rows = 15
    gap = 20 * Scale.width
    row_height = font\getHeight!
    x = 400 * Scale.width
    width = Screen_Size.width - (x * 2)
    height = row_height * num_rows
    y = Screen_Size.half_height - (height / 2)

    end_y = y + height
    Renderer\drawAlignedMessage "Score: " .. ScoreTracker.score, end_y + ((Screen_Size.height - end_y) / 4), nil, Renderer\newFont 60

    setColor 0, 0, 0, 127
    love.graphics.rectangle "fill", x, y, width, height

    setColor 0, 255, 255, 255
    love.graphics.setFont font

    ScoreTracker.high_scores\sort!
    for i = 1, (math.min num_rows, #ScoreTracker.high_scores.elements)
      node = ScoreTracker.high_scores.elements[i]
      row_y = y + (row_height * (i - 1))
      name = i .. ") "
      if i < 10
        name ..= " "
      love.graphics.printf name .. node.name, x + gap, row_y, width - (2 * gap), "left"
      love.graphics.printf node.score, x + gap, row_y, width - (2 * gap), "right"

    love.graphics.pop!
