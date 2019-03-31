vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  float sum = texture_coords.x + texture_coords.y;

  float r = (cos(sum) + 1) / 2;
  float g = sqrt((texture_coords.x * texture_coords.x) + (texture_coords.y * texture_coords.y)) / sqrt(2);
  float b = (sin(sum) + 1) / 2;

  vec4 pixel = Texel(texture, texture_coords);
  return vec4(r, g, b, 1) * pixel * color;
}
