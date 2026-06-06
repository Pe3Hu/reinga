shader_type canvas_item;

uniform float time_scale = 1.0;
uniform float radius = 0.42;
uniform float intensity = 1.2;
uniform vec2 stretch = vec2(1.6, 1.6);
uniform float grid_scale = 3.0;
uniform vec2 corner_push = vec2(0.25);
uniform int state = 0;

float diamond(vec2 p) {
    p *= stretch;
    float d = abs(p.x) + abs(p.y);
    float core = 1.0 / (d * 10.0 + 1.0);
    float glow = 1.0 / (d * 3.5 + 1.0);
    return core + glow * 0.65;
}

float axes(vec2 p) {
    p *= stretch;
    float x_line = 1.0 / (abs(p.x) * 25.0 + 1.0);
    float y_line = 1.0 / (abs(p.y) * 25.0 + 1.0);
    return x_line + y_line;
}

float is_visible(int i) {
    if (state == 0) return 1.0;

    if (state == 1 && (i == 0 || i == 1)) return 0.0;
    if (state == 2 && (i == 1 || i == 3)) return 0.0;
    if (state == 3 && (i == 3 || i == 2)) return 0.0;
    if (state == 4 && (i == 2 || i == 0)) return 0.0;

    return 1.0;
}

void fragment() {
    vec2 grid = UV * grid_scale;

    vec2 centers[4];
    centers[0] = vec2(1.0, 1.0) - corner_push;
    centers[1] = vec2(2.0, 1.0) + vec2(corner_push.x, -corner_push.y);
    centers[2] = vec2(1.0, 2.0) + vec2(-corner_push.x, corner_push.y);
    centers[3] = vec2(2.0, 2.0) + corner_push;

    float result = 0.0;

    for (int i = 0; i < 4; i++) {
        float vis = is_visible(i);

        vec2 p = grid - centers[i];
        float mask = smoothstep(radius, 0.0, abs(p.x) + abs(p.y));

        float d = diamond(p);
        float ax = axes(p);

        float pulse = 0.6 + 0.4 * sin(TIME * time_scale + float(i) * 2.0);
        float shape = d + ax;

        result += shape * mask * pulse * vis;
    }

    result *= intensity;
    COLOR = vec4(vec3(result), result);
}