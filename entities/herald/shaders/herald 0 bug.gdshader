shader_type canvas_item;

#define iTime TIME

float rand(vec2 n) {
    return fract(sin(cos(dot(n, vec2(12.9898,12.1414)))) * 83758.5453);
}

float noise(vec2 n) {
    const vec2 d = vec2(0.0, 1.0);
    vec2 b = floor(n);
    vec2 f = smoothstep(vec2(0.0), vec2(1.0), fract(n));

    return mix(
        mix(rand(b), rand(b + d.yx), f.x),
        mix(rand(b + d.xy), rand(b + d.yy), f.x),
        f.y
    );
}

float fbm(vec2 n) {
    float total = 0.0;
    float amplitude = 1.0;

    for (int i = 0; i < 5; i++) {
        total += noise(n) * amplitude;
        n += n * 1.7;
        amplitude *= 0.47;
    }
    return total;
}

void fragment() {

    vec2 uv = UV;
    uv.y = 1.0 - uv.y;

    float t = iTime;

    // --- Shadertoy-like coord system ---
    vec2 p = uv * 3.5;

    // --- ONLY FIX #1: micro-dither (убирает полосы) ---
    p += (rand(p + t) - 0.5) * 0.003;

    p += sin(p.yx * 4.0 + vec2(.2,-.3) * t) * 0.04;
    p += sin(p.yx * 8.0 + vec2(.6,.1) * t) * 0.01;

    p.x -= t / 1.1;

    float q  = fbm(p - t * 0.3 + sin(t + 0.5)/2.0);
    float qb = fbm(p - t * 0.4 + 0.1*cos(t)/2.0);
    float q2 = fbm(p - t * 0.44 - 5.0*cos(t)/2.0) - 6.0;
    float q3 = fbm(p - t * 0.9  - 10.0*cos(t)/15.0) - 4.0;
    float q4 = fbm(p - t * 1.4  - 20.0*sin(t)/14.0) + 2.0;

    q = (q + qb - 0.4*q2 - 2.0*q3 + 0.6*q4) / 3.8;

    vec2 r = vec2(
        fbm(p + q/2.0 + t*0.1),
        fbm(p + q - t*0.9)
    );

    float flame =
        1.0 / pow((r.y + r.y) * max(0.0, p.y) + 0.1, 4.0);

    vec3 color = vec3(1.0, 0.2, 0.05) * flame;

    color = color / (1.0 + max(vec3(0.0), color));

    COLOR = vec4(color, 1.0);
}