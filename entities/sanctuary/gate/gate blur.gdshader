shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform int selected_row = 0;
uniform int selected_col = 0;

uniform float blur_strength = 0.8;
uniform float blur_amount = 1.0;

const float GRID = 3.0;

vec4 blur(vec2 uv, vec2 pixel_size) {
    vec4 col = vec4(0.0);
    float total = 0.0;

    for (float x = -2.0; x <= 2.0; x++) {
        for (float y = -2.0; y <= 2.0; y++) {
            vec2 offset = vec2(x, y) * pixel_size * blur_strength;
            col += texture(SCREEN_TEXTURE, uv + offset);
            total += 1.0;
        }
    }

    return col / total;
}

void fragment() {
    vec2 uv = UV; // <-- ключевая правка

    vec2 cell_uv = uv * GRID;
    ivec2 cell = ivec2(floor(cell_uv));

    bool keep_sharp =
        (cell.x == selected_col) ||
        (cell.y == selected_row);

    vec4 sharp = texture(SCREEN_TEXTURE, SCREEN_UV);

    if (keep_sharp) {
        COLOR = sharp;
    } else {
        vec4 blurred = blur(SCREEN_UV, SCREEN_PIXEL_SIZE);
        COLOR = mix(sharp, blurred, blur_amount);
    }
}