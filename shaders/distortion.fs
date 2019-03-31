vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  vec4 pixel = Texel(texture, texture_coords);
  int num = int((texture_coords.x + texture_coords.y) * (screen_coords.x + screen_coords.y));
  num = int(mod(num, 3));
  if (num == 0) {
    return pixel * color * vec4(0, 1, 1, 1);
  } else if (num == 1) {
    return pixel * color * vec4(1, 0, 1, 1);
  } else {
    return pixel * color * vec4(1, 1, 0, 1);
  }
}
