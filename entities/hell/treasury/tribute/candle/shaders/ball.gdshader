shader_type canvas_item;

uniform float speed         : hint_range(0.0, 2.0) = 1.0; 
uniform float glow_strength : hint_range(0.0, 3.0) = 0.7;
uniform float edge_softness : hint_range(0.0, 1.0) = 0.15;
uniform vec4  color : source_color = vec4(0.98, 0.047, 0.047, 1.0);

uniform float noise_scale = 3.0;
uniform float roughness = 0.65;
uniform float lacunarity = 2.0;
uniform int detail = 3;

vec2 random2(vec2 st, float seed) {
    st = vec2(dot(st, vec2(127.1, 311.7)),
              dot(st, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(st) * 43758.5453123 * seed);
}

float noise(vec2 st, float seed) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(
        mix(dot(random2(i + vec2(0.0), seed), f),
            dot(random2(i + vec2(1.0, 0.0), seed), f - vec2(1.0, 0.0)), u.x),
        mix(dot(random2(i + vec2(0.0, 1.0), seed), f - vec2(0.0, 1.0)),
            dot(random2(i + vec2(1.0), seed), f - vec2(1.0)), u.x),
        u.y
    );
}

float fbm(vec2 st) {
    float value = 0.0;
    float amp = 0.5;

    for (int i = 0; i < detail; i++) {
        value += amp * noise(st, float(i) + 1.0);
        st *= lacunarity;
        amp *= roughness;
    }

    return value * 0.5 + 0.5;
}

vec3 neon(float val, vec3 col) {
    float ramp = clamp(val, 0.0, 1.0);

    ramp = pow(ramp, 1.5);

    vec3 outp = vec3(0.0);

    outp += pow(col, vec3(3.0)) * ramp;

    ramp = pow(ramp, 2.0);
    outp += col * ramp;

    ramp = pow(ramp, 3.0);
    outp += vec3(1.2) * ramp;

    return outp;
}

void fragment() {
    vec2 uv = (UV - vec2(0.5)) / 0.4;
    float dist = length(uv);

    float fade = smoothstep(0.8, 0.2, dist);
    float edge = smoothstep(0.5, 0.5 - edge_softness, dist);

    vec2 n_uv = uv * noise_scale + vec2(TIME * speed, TIME * speed * 0.4);
    float n = fbm(n_uv);

    float pulse = 0.92 + 0.08 * sin(TIME * speed * 2.5);

    float energy = fade * edge * pulse;

    float glow = energy * glow_strength * (0.6 + n);

    glow += pow(glow, 2.2) * 0.8;

    vec3 base_col = color.rgb * (0.6 + n);

    vec3 final_col = neon(glow, base_col);

    COLOR = vec4(final_col, glow);
}