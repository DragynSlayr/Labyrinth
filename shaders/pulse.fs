extern float elapsed = 0;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  float r = (sin(elapsed) + 1) / 2;
  float g = elapsed;
  float b = (cos(elapsed) + 1) / 2;
  vec4 pixel = Texel(texture, texture_coords);
  return color * pixel * vec4(r, g, b, 1);
}
