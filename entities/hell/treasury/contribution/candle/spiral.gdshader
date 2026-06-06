shader_type canvas_item;

uniform float speed = 0.4;
uniform float pixelSize = 0.015;
uniform float alpha = 0.95;
uniform float flickerStrength = 0.15;

uniform vec3 toColor = vec3(0.4, 0.35, 0.2);
uniform vec3 fromColor = vec3(0.9, 0.2, 0.1);

uniform float hueShift = 0.0;
uniform float saturationFactor = 1.0;

uniform float particleCount = 120.0;
uniform float brightness = 0.001;

uniform float fireShift = 1.2;
uniform float fireShiftFrequency = 10.0;

uniform vec2 size = vec2(0.05, 2.0);
uniform vec2 glow = vec2(0.001, 0.04);

uniform float aspectRatio = 1.0;
uniform vec2 posOffset = vec2(0.0, -0.9);

float Hash1(float t) {
    return fract(cos(t * 124.97) * 248.842) - 0.5;
}

float saturate(float x) {
    return clamp(x, 0.0, 1.0);
}

vec3 rgb_to_hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1e-10;
    return vec3(abs(q.w - q.y) / (6.0 * d + e) + q.z, d / (q.x + e), q.x);
}

vec3 hsv_to_rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 Simulate(vec2 uv, float t) {
    vec3 res = vec3(0.0);

    for (float i = 0.0; i < particleCount; i++) {
        float ct = fract(t + (i + 1.0) / particleCount);
        float seed = Hash1((i + 1.0) * (t - ct));

        vec2 dir = vec2(0.0, size.y);

        dir.x += (cos(t * seed) * sin(ct * fireShiftFrequency))
               * mix(0.0, fireShift, log(ct));

        float cb = saturate(mix(brightness, 0.0, ct));

        vec2 off = vec2(seed * size.x, 0.0);

        res += mix(fromColor * abs(seed), toColor, ct)
            * smoothstep(glow.x, glow.y,
                cb / length(uv - off - (dir * ct))
            );
    }

    return res;
}

void fragment() {
    vec2 frag_coords = UV * 2.0 - 1.0;
    frag_coords.x *= aspectRatio;
    frag_coords.y *= -1.0;
    frag_coords -= posOffset;

    vec2 pixelated = floor(frag_coords / pixelSize) * pixelSize;

    float t = TIME * speed + 100.0;

    vec3 fire_color = Simulate(pixelated, t);

    // ===== FIXED HUE MIX =====
    vec3 hsv = rgb_to_hsv(fire_color);

    hsv.x += hueShift;
    hsv.x = hsv.x - floor(hsv.x); // стабильный wrap 0..1

    hsv.y *= saturationFactor;
    hsv.y = clamp(hsv.y, 0.0, 1.0);

    vec3 result = hsv_to_rgb(hsv);

    // flicker
    float flicker = (Hash1(t * 5.0) + 0.5) * flickerStrength;
    result *= (1.0 + flicker);

    float intensity = max(max(result.r, result.g), result.b);
    float final_alpha = smoothstep(0.01, 0.5, intensity) * alpha;

    COLOR = vec4(result * alpha, final_alpha);
}