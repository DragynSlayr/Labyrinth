extern vec2 screen_size;
extern vec2 player_pos;
extern float size = 10; // increase to decrease radius

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  float dist = length(screen_size);
  vec2 sep = screen_coords - player_pos;
  float num = length(sep) / dist;
  num *= size;
  num = clamp(1.0 - num, 0, 1);

  vec4 pixel = Texel(texture, texture_coords);
  return color * pixel * vec4(num, num, num, 1);
}
