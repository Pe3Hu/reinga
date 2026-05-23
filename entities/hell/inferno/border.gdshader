shader_type canvas_item;

float rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 12.1414))) * 83758.5453);
}

float noise(vec2 n) {
    vec2 d = vec2(0.0, 1.0);
    vec2 b = floor(n);
    vec2 f = fract(n);
    return mix(
        mix(rand(b), rand(b + d.yx), f.x),
        mix(rand(b + d.xy), rand(b + d.yy), f.x),
        f.y
    );
}

vec3 ramp(float t) {
    return t <= 0.5
        ? vec3(1.0 - t * 1.4, 0.2, 1.05) / t
        : vec3(0.3 * (1.0 - t) * 2.0, 0.2, 1.05) / t;
}

float fire(vec2 n) {
    return noise(n)
        + noise(n * 2.1) * 0.6
        + noise(n * 5.4) * 0.42;
}

vec3 getLine(vec3 col, vec2 uv, mat2 mtx, float shift) {
    float t = TIME;

    uv = uv * mtx;

    uv.x += uv.y < 0.5 ? 23.0 + t * 0.35 : -11.0 + t * 0.3;
    uv.y = abs(uv.y - shift);
    uv *= 5.0;

    float q = fire(uv - t * 0.013) / 2.0;

    vec2 r = vec2(
        fire(uv + q / 2.0 + t - uv.x - uv.y),
        fire(uv + q - t)
    );

    float grad = pow((r.y + r.y) * max(0.0, uv.y) + 0.1, 4.0);

    vec3 color = ramp(grad);
    color /= (1.5 + max(vec3(0.0), color));

    if (color.b < 0.00000005) {
        color = vec3(0.0);
    }

    return mix(col, color, color.b);
}

void fragment() {
    vec2 uv = UV;

    vec3 color = vec3(0.0);

    color = getLine(color, uv, mat2(vec2(1.0, 1.0), vec2(0.0, 1.0)), 1.02);
    color = getLine(color, uv, mat2(vec2(1.0, 1.0), vec2(1.0, 0.0)), 1.02);
    color = getLine(color, uv, mat2(vec2(1.0, 1.0), vec2(0.0, 1.0)), -0.02);
    color = getLine(color, uv, mat2(vec2(1.0, 1.0), vec2(1.0, 0.0)), -0.02);

    COLOR = vec4(color, 1.0);
}