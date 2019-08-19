export class Stack extends LinkedList
  new: =>
    super!

  remove: =>
    if @head == nil
      return ""
    data = ""
    if @length == 1
      data = @head.data
      @head = nil
    else
      n = @head
      for i = 1, @length - 2
        n = n.next
      data = n.next.data
      n.next = nil
    @length -= 1
    return data

  peekLast: =>
    last = @remove!
    @add last
    return last
