shader_type canvas_item;

uniform float time_scale = 0.2;

void fragment() {
    vec2 fragCoord = FRAGCOORD.xy;
    vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    float iTime = TIME * time_scale;

    vec2 uv = (2.0 * fragCoord - iResolution.xy) / min(iResolution.x, iResolution.y);

    for (float i = 1.0; i < 10.0; i++) {
        uv.x += 0.6 / i * cos(i * 2.5 * uv.y + iTime);
        uv.y += 0.6 / i * cos(i * 1.5 * uv.x + iTime);
    }

    float val = 0.1 / abs(sin(iTime - uv.y - uv.x));

    COLOR = vec4(vec3(val), 1.0);
}