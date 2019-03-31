-- Class for handling music controls
export class MusicHandler
  new: =>
    @sounds = {}

  -- Play the current sound
  play: (idx) =>
    if true
      return
    if idx > 0
      if @sounds[idx].audio\isPlaying!
        @sounds[idx].audio\rewind!
      @sounds[idx]\start!

  -- Toggle playback of current sound
  toggle: (idx) =>
    @sounds[idx]\toggle!

  -- Stop playback
  stop: (idx) =>
    @sounds[idx]\stop!

  setVolume: (idx, value) =>
    @sounds[idx]\setVolume value

  setPitch: (idx, value) =>
    @sounds[idx]\setPitch value

  setLooping: (idx, value) =>
    @sounds[idx]\setLooping value

  add: (sound) =>
    for k, v in pairs @sounds
      if v.name == sound.name
        return k
    table.insert @sounds, sound
    return #@sounds

  get: (idx) =>
    return @sounds[idx]
