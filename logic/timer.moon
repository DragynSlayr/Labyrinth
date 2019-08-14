export class Timer
  new: (@delay, @parent, @action, @repeating = true) =>
    @elapsed = 0
    @done = false
    TimerHandler\add @

  update: (dt) =>
    @elapsed += dt
    while @elapsed >= @delay and not @done
      @elapsed -= @delay
      @action!
      if not @repeating
        @done = true
        break
    if @done
      TimerHandler\remove @
