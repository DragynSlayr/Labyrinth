class Node
  new: (data) =>
    @data = data
    @next = nil

export class LinkedList
  new: =>
    @head = nil
    @length = 0

  add: (object) =>
    new_node = Node object
    if @head == nil
      @head = new_node
    else
      n = @head
      for i = 1, @length - 1
        n = n.next
      n.next = new_node
    @length += 1

  remove: =>
    if @head == nil
      return ""
    data = @head.data
    @head = @head.next
    @length -= 1
    return data

  print: =>
    n = @head
    s = "Len: " .. @length .. "; "
    while n
      s ..= tostring n.data
      if n.next
        s ..= ", "
      else
        s ..= ";"
      n = n.next
    print s
