export class ResoureCacher
  new: =>
    @images = {}
    @sounds = {}
    @sounds.static = {}
    @sounds.dynamic = {}

  loadImage: (path) =>
    if not @images[path]
      flags = {}
      flags["linear"] = false
      flags["mipmaps"] = true
      @images[path] = love.graphics.newImage path, flags
    return @images[path]

  loadSound: (path, static = false) =>
    if static
      if not @sounds.static[path]
        @sounds.static[path] = love.audio.newSource path, "static"
      return @sounds.static[path]
    else
      if not @sounds.dynamic[path]
        @sounds.dynamic[path] = love.audio.newSource path
      return @sounds.dynamic[path]
