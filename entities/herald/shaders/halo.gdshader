shader_type canvas_item;

uniform float intensity = 0.15;//0.45
uniform float center = 50.0;
uniform float offset = 3.0;
uniform float time_scale = 1.0;
uniform float radius = 0.33;//0.6;

void fragment() {

    vec2 fragCoord = UV * (1.0 / SCREEN_PIXEL_SIZE);
    vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;

    vec2 p = (2.0 * fragCoord - iResolution) / iResolution.y;

    float r = length(p) * radius;

    vec2 uv = vec2(0.0, r);
    uv = (2.0 * uv) - 1.0;

    float y = max(abs(uv.y), 0.001);

    float pulse = 0.2 - intensity * sin(TIME * time_scale);

    float core = (offset / (center * y)) * pulse;

    float glow1 = offset / (center * (y + 0.05));
    float glow2 = offset / (center * (y + 0.12));
    float glow3 = offset / (center * (y + 0.22));

    float beam =
        core +
        glow1 * 0.4 +
        glow2 * 0.3 +
        glow3 * 0.2;

    beam = smoothstep(0.0, 2.0, beam);

    vec3 color = vec3(beam);

    COLOR = vec4(color, 1.0);
}