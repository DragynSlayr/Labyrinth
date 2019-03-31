class ScoreNode
  new: (score, name) =>
    @score = score
    @name = name
    @next = nil

export class ScoreArray
  new: =>
    @elements = {}
    @size = 0
    @sorted = true

  add: (score, name) =>
    node = ScoreNode (tonumber score), (tostring name)
    for k, v in pairs @elements
      if v.name == node.name and v.score == node.score
        return

    table.insert @elements, node
    @size += 1
    @sorted = false

  remove: =>
    if @size > 0
      if not @sorted
        @sort!
      node = table.remove @elements, 1
      @size -= 1
      return node

  sort: =>
    if @sorted
      return
    for i = 1, #@elements - 1
      max = i
      for j = i + 1, #@elements
        if @elements[max].score < @elements[j].score
          max = j
      @swap i, max
    @sorted = true

  swap: (i, j) =>
    temp = @elements[i]
    @elements[i] = @elements[j]
    @elements[j] = temp

  print: =>
    if not @sorted
      @sort!
    s = ""
    for k, v in pairs @elements
      s ..= v.name .. ", " .. v.score
      if k ~= #@elements
        s ..= "\n"
    print s

  getTopScores: (n) =>
    n = math.min n, #@elements
    @sort!
    temp = ScoreArray!
    for i = 1, n
      node = @elements[i]
      temp\add node.score, node.name
    temp\sort!
    return temp

export class Score
  new: =>
    @s = require "socket"
    @score = 0
    @score_threshold = 10000
    @shift = 128

    if not love.filesystem.getInfo "HIGH_SCORES"
      love.filesystem.write "HIGH_SCORES", ""

    @high_scores = ScoreArray!

    @socket = nil

    @server_address = "70.72.212.179"
    @server_port = 19615

    @connected = false
    --@tryConnection!

    if not @connected
      @loadScores!
    else
      @retrieveScores!

    @elapsed = 0
    @update_delay = 1

  tryConnection: =>
    @socket = @s.udp!
    @socket\settimeout 0
    @socket\setpeername @server_address, @server_port
    @connected = true

  disconnect: =>
    if @connected
      @socket\close!

  retrieveScores: =>
    if not @connected
      return

    @socket\send "update"

    temp = ScoreArray!
    data = ""
    while data
      data, msg = @socket\receive!
      if data
        splitted = split data, "\t"
        score = tonumber splitted[2]
        name = splitted[1]
        temp\add score, name
      elseif msg ~= "timeout"
        error "Network error: " .. tostring msg

    if #temp.elements > #@high_scores.elements
      temp\sort!
      @high_scores = temp

  loadScores: =>
    @high_scores = ScoreArray!
    contents, size = love.filesystem.read "HIGH_SCORES"
    if size > 0
      lines = split contents, "\n"
      for k, v in pairs lines
        line = @decode v
        splitted = split line, "\t"
        @high_scores\add splitted[2], splitted[1]

  saveScores: =>
    temp = ScoreArray!
    s = ""
    while @high_scores.size > 0
      node = @high_scores\remove!
      temp\add node.score, node.name
      s ..= @encode node.name .. "\t" .. node.score
      if @high_scores.size ~= 0
        s ..= "\n"
    love.filesystem.write "HIGH_SCORES", s
    @high_scores = temp

  encode: (str, shift = @shift) =>
    s = ""
    for i = 1, #str
      char = string.sub str, i, i
      num = string.byte char
      num += shift
      s ..= string.char num
    return s

  decode: (str) =>
    return @encode str, -@shift

  update: (dt) =>
    if @score >= @score_threshold
      score_change = @score - @score_threshold
      score_change = math.floor score_change / 10000
      score_change += 1
      @score_threshold += 10000
    if Driver.game_state == Game_State.game_over
      @elapsed += dt
      if @elapsed > @update_delay
        @elapsed = 0
        @retrieveScores!

  addScore: (score) =>
    @score += score

  submitScore: (text) =>
    if @connected
      name = tostring text
      score = tonumber @score
      dg = string.format "%s\t%d", name, score
      @socket\send dg
    else
      name = text
      score = tostring @score
      @high_scores\add score, name
