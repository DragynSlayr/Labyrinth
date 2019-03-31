extern float amount = 0;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  float val = amount / 2;
  if (val <= texture_coords.x && (1 - val) >= texture_coords.x && val <= texture_coords.y && (1 - val) >= texture_coords.y) {
    vec4 pixel = Texel(texture, texture_coords);
    return pixel * color;
  } else {
    return vec4(132 / 255, 87 / 255, 15 / 255, 200 / 255);
  }
}
