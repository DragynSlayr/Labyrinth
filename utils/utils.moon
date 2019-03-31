-- Seed random and dispose of some values
math.randomseed os.time!
for i = 1, 3 do math.random!

-- Get a random sign
export randomSign = () ->
  if math.random 0, 1 == 1
    return 1
  else
    return -1

-- Get a random point on a circle
-- radius: The radius of the circle
export getRandomUnitStart = (radius = Screen_Size.height / 3) ->
  vec = Vector 1, 0
  num = ((math.random 0, 361) / 360) * 2 * math.pi
  vec\rotate num
  return vec\multiply radius

-- Clamps a number between two values
-- x: The number to clamp
-- min: Minimum value for number
-- max: Maximum value for number
export clamp = (x, min, max) ->
  -- Return a number in the range [min, max]
  if x <= min
    return min
  elseif x >= max
    return max
  else
    return x

-- Shuffles a list in place
-- list: The list to shuffle
export shuffle = (list) ->
  copy = {}
  -- Copy the list
  for k, v in pairs list
    copy[k] = v

  -- Shuffle the list
  for k, v in pairs list
    i = math.random #copy
    list[k] = copy[i]
    table.remove copy, i

-- Get random element from list
-- list: The list to choose from
export pick = (list) ->
  num = math.random(1, #list)
  return list[num]

-- Maps a value in [low, high] to [newLow, newHigh]
-- value: The value to map
-- low: Original lowest possible value
-- high: Original highest possible value
-- newLow: New lowest value
-- newHigh: New highest value
export map = (value, low, high, newLow, newHigh) ->
  b = (high - low)
  if b == 0
    return 0
  else
    a = (value - low) * (newHigh - newLow)
    return (a / b) + newLow

export ljust = (str, length) ->
  str = tostring str
  if #str >= length
    return str
  else
    num = length - #str
    for i = 1, num
      str ..= " "
    return str

export rjust = (str, length) ->
  str = tostring str
  if #str >= length
    return str
  else
    num = length - #str
    for i = 1, num
      str = " " .. str
    return str

export reverse = (str) ->
  str = tostring str
  s2 = ""
  for i = #str, 1, -1
    s2 ..= string.sub str, i, i
  return s2

export lstrip = (str) ->
  str = tostring str
  found = false
  s2 = ""
  for i = 1, #str
    char = string.sub str, i, i
    if not found
      if not (char == ' ' or char == '\n' or char == '\t' or char == '\r')
        found = true
        s2 ..= char
    else
      s2 ..= char
  return s2

export rstrip = (str) ->
  return reverse lstrip reverse str

export strip = (str) ->
  return lstrip rstrip str

export split = (str, char) ->
  str = tostring str
  splitted = {}
  s = ""
  for i = 1, #str
    c = string.sub str, i, i
    if c == char
      splitted[#splitted + 1] = s
      s = ""
    else
      s ..= c
  splitted[#splitted + 1] = s
  return splitted

export trim = (str, len) ->
  str = tostring str
  if #str <= len
    return str
  else
    s = ""
    for i = 1, len
      s ..= string.sub str, i, i
    return s

export removeChars = (str, chars = {}) ->
  str = tostring str
  s = ""
  for i = 1, #str
    c = string.sub str, i, i
    found = false
    for k, v in pairs chars
      if v == c
        found = true
        break
    if not found
      s ..= c
  return s

export toTitle = (s, sep = " ") ->
  title = ""
  for k, v in pairs (split s, sep)
    v = (string.upper (string.sub v, 1, 1)) .. (string.sub (string.lower v), 2)
    title ..= v .. " "
  return (strip title)

export startsWith = (s, x) ->
  return ((string.sub s, 1, #x) == x)

export tableToString = (t, d = 0) ->
  if (type t) ~= "table"
    error "This function only works on Tables"
  s = ""
  for i = 1, d
    s ..= "\t"
  s = "{"
  count = 0
  for k, v in pairs t
    count += 1
  if count > 0
    s ..= "\n"
    for i = 0, d
      s ..= "\t"
    idx = 1
    for k, v in pairs t
      if (type v) == "table"
        s ..= tableToString t[k], d + 1
      else
        s ..= "\'" .. (tostring v) .. "\'"
      if idx ~= count
        s ..= ", "
      else
        s ..= " "
      idx += 1
  s ..= "\n"
  for i = 1, d
    s ..= "\t"
  s ..= "}"
  return s

export copyTable = (t) ->
  copy = {}
  for k, v in pairs t
    if (type v) == "table"
      copy[k] = copyTable t[k]
    else
      copy[k] = v
  return copy

export lengthof = (l) ->
  num = 0
  for k, v in pairs l
    if v
      num += 1
  return num

export concatTables = (t1, t2) ->
  t3 = {}
  for k, v in pairs t1
    table.insert t3, v
  for k, v in pairs t2
    table.insert t3, v
  return t3

export indexOf = (t, i) ->
  for k, v in pairs t
    if v == i
      return k
  return -1

export tableContains = (t, i) ->
  return (indexOf t, i) >= 1

export reverseTable = (t) ->
  reversed = {}
  for k, v in pairs t
    table.insert reversed, 1, v
  return reversed

export getAllDirectories = (root) ->
  files = getAllFiles root
  directories = {}
  for k, v in pairs files
    splitted = split v, "/"
    directory = splitted[1]
    for i = 2, #splitted - 1
      directory ..= "/" .. splitted[i]
    if not tableContains directories, directory
      table.insert directories, directory
  return directories

export getAllFiles = (root, current = {}) ->
  if love.filesystem.isDirectory root
    files = love.filesystem.getDirectoryItems root
    for k, v in pairs files
      current = getAllFiles root .. "/" .. v, current
  else
    table.insert current, root
  return current

export readKey = (key) ->
  contents, size = love.filesystem.read "SETTINGS"
  lines = split contents, "\n"
  for k, v in pairs lines
    splitted = split v, " "
    read_key, value = splitted[1], splitted[2]
    if read_key == key
      return value
  return nil

export writeKey = (key, value) ->
  contents, size = love.filesystem.read "SETTINGS"
  lines = split contents, "\n"
  key_found = false
  for k, v in pairs lines
    splitted = split v, " "
    read_key, read_value = splitted[1], splitted[2]
    if read_key == key
      lines[k] = key .. " " .. value
      key_found = true
      break
  if not key_found
    table.insert lines, key .. " " .. value
  s = ""
  for i = 1, #lines - 1
    s ..= lines[i] .. "\n"
  s ..= lines[#lines]
  love.filesystem.write "SETTINGS", s
