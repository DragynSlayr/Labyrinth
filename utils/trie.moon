class Node
  new: (data, is_word) =>
    @data = data
    @children = {}
    @is_word = is_word

  addChild: (node) =>
    if not @hasChild node.data
      table.insert @children, node

  hasChild: (word) =>
    found = false
    for k, v in pairs @children
      if v.data == word
        found = true
        break
    return found

  getChild: (word) =>
    for k, v in pairs @children
      if v.data == word
        return v

export class Trie
  new: =>
    @head = Node "", false

  add: (word) =>
    --print "Started adding " .. word
    length = string.len word
    s = ""
    current_node = @head
    for i = 1, length
      s ..= string.sub word, i, i
      new_node = Node s, (s == word)
      if current_node\hasChild new_node.data
        current_node = current_node\getChild s
      else
        current_node\addChild new_node
        current_node = new_node

  hasWord: (word) =>
    length = string.len word
    s = ""
    current_node = @head
    for i = 1, length
      s ..= string.sub word, i, i
      new_node = Node s, (s == word)
      if current_node\hasChild new_node.data
        current_node = current_node\getChild s
      else
        return false
    return current_node.is_word

  hasNode: (word) =>
    length = string.len word
    s = ""
    current_node = @head
    for i = 1, length
      s ..= string.sub word, i, i
      new_node = Node s, (s == word)
      if current_node\hasChild new_node.data
        current_node = current_node\getChild s
      else
        return false
    return true

  getNode: (word) =>
    length = string.len word
    s = ""
    current_node = @head
    for i = 1, length
      s ..= string.sub word, i, i
      new_node = Node s, (s == word)
      if current_node\hasChild new_node.data
        current_node = current_node\getChild s
    return current_node

  getWords: (start) =>
    words = {}
    if @hasNode start
      node = @getNode start
      to_traverse = LinkedList!
      to_traverse\add node
      found = LinkedList!
      found\add node
      while to_traverse.length > 0
        current_node = to_traverse\remove!
        for k, v in pairs current_node.children
          to_traverse\add v
          found\add v
      while found.length > 0
        current_node = found\remove!
        if current_node.is_word
          table.insert words, current_node.data
    return words

  print: (node = @head) =>
    to_traverse = LinkedList!
    to_traverse\add node
    s = ""
    while to_traverse.length > 0
      current_node = to_traverse\remove!
      s ..= current_node.data
      if #current_node.children > 0
        s ..= " -> "
      else
        s ..= " ~|"
      for k, v in pairs current_node.children
        to_traverse\add v
    print s
