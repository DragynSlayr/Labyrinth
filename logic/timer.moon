export class Timer
  new: (@delay, @action, @repeating = true) =>
    @elapsed = 0
    @done = false

  update: (dt) =>
    @elapsed += dt
    while @elapsed >= @delay and not @done
      @elapsed -= @delay
      @action!
      if not @repeating
        @done = true
        break
