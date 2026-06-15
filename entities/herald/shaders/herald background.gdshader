shader_type canvas_item;

uniform vec3 final_color : source_color = vec3(1.0, 1.0, 1.0);

void fragment() {
    vec2 fragCoord = FRAGCOORD.xy;
    vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    float iTime = TIME;

    vec2 uv = (1.2 * fragCoord - iResolution.xy) / min(iResolution.x, iResolution.y);

    uv.y *= -1.0;

    for (float i = 2.15; i < 7.150; i++) {
        uv.y += i * 0.1 / i *
            sin(uv.x * i * i + iTime * 0.5) *
            sin(uv.y * i * i + iTime * 0.5);
    }

    vec3 col;
    col.r = uv.y + final_color.r;
    col.g = uv.y + final_color.g;
    col.b = uv.y + final_color.b;

    COLOR = vec4(col, 1.0);
}
