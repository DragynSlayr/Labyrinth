-- Class for representing and playing a Sound
export class Sound

  -- name: The path to the Sound file
  -- volume: Initial volume of the Sound
  -- looping: Whether the Sound should loop
  -- pitch: The initial pitch of the Sound
  -- static: Whether the Sound should change or not
  new: (name, volume = 1.0, looping = true, pitch = 1.0, static = false) =>

    path = "assets/sounds/" .. name
    if love.filesystem.getInfo (PATH_PREFIX .. path)
      path = PATH_PREFIX .. path

    -- Load Sound
    if static
      @audio = ResoureLoader\loadSound path, true
    else
      @audio = ResoureLoader\loadSound path

    @name = name

    -- Set initial values
    @audio\setLooping looping
    @audio\setPitch pitch
    @audio\setVolume volume

  -- Start the Sound
  start: =>
    @audio\play!

  -- Toggle playing of the Sound
  toggle: =>
    if @audio\isPaused!
      @audio\resume!
    else
      @audio\pause!

  -- Stop the Sound
  stop: =>
    @audio\stop!

  -- Set the volume of the Sound
  -- volume: The new volume
  setVolume: (volume) =>
    @audio\setVolume volume

  -- Set the pitch of the Sound
  -- pitch: The new pitch
  setPitch: (pitch) =>
    @audio\setPitch pitch

  -- Set the looping of the Sound
  -- looping: The new looping
  setLooping: (looping) =>
    @audio\setLooping looping

  -- Gets the volume of the Sound
  getVolume: =>
    return @audio\getVolume!

  -- Gets the pitch of the Sound
  getPitch: =>
    return @audio\getPitch!

  -- Gets the looping of the Sound
  getLooping: =>
    return @audio\getLooping!
