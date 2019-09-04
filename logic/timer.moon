export class Timer
  new: (@delay, @parent, @action, @repeating = true) =>
    @elapsed = 0
    @done = false
    @enabled = true
    TimerHandler\add @

  update: (dt) =>
    if not @enabled return
    @elapsed += dt
    if @elapsed >= @delay and not @done
      @elapsed = 0
      @action!
      if not @repeating
        @done = true
    if @done
      TimerHandler\remove @
