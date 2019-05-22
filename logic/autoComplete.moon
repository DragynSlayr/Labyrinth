export class AutoComplete
  new: =>
    @resetText!

    @trie = Trie!
    @font = love.graphics.newFont 20

    if DEBUG_MENU_ENABLED
      @addWords!

    @text_box = nil
    @reset_chars = {".", " ", "\\", "(", ")", "{", "}", "[", "]"}

  addWords: =>
    contents, size = love.filesystem.read "words.txt"
    splitted = split contents, "\n"
    for k, v in pairs splitted
      @trie\add removeChars v, {"\r", "\n", "\t", " "}

  resetText: =>
    @text = ""
    @last_text = ""
    @words = {}

  keypressed: (key, scancode, isrepeat) =>
    if @text_box.active
      if key == "return"
        @resetText!
      elseif key == "tab"
        if #@text > 0 and #@words > 0
           @text_box\addText @words[1], @text
        @resetText!
      elseif key == "backspace"
        @text = string.sub @text, 1, #@text - 1
        if #@text == 0
          @resetText!

  textinput: (text) =>
    if @text_box.active
      if tableContains @reset_chars, text
        @resetText!
      else
        if text ~= '`'
          @text ..= text

  update: (dt) =>
    @max_words = @text_box.height - (@text_box.cursor.position.y + @font\getHeight! + (5 * Scale.height))
    @max_words /= @font\getHeight! * 1.25
    @max_words = math.ceil @max_words
    if @last_text ~= @text
      @last_text = @text
      @words = @trie\getWords @text
      table.sort @words
      if #@words > @max_words
        words = {}
        for i = 1, @max_words
          table.insert words, @words[i]
        @words = words

  draw: =>
    Camera\unset!

    setColor 0, 255, 255, 255
    love.graphics.setFont @font

    height = @font\getHeight!
    x = @text_box.cursor.position.x
    y = @text_box.cursor.position.y + height + (5 * Scale.height)

    for k, word in pairs @words
      if y + (height * 1.25) < (@text_box.x + @text_box.height)
        love.graphics.printf word, x, y, @font\getWidth word, "center"
        y += height * 1.25
      else
        break

    Camera\set!
