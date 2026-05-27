shader_type canvas_item;
render_mode blend_mix;

// --- FIREBALL PARAMS ---
uniform float time : hint_range(0.0, 10.0);
uniform float frame_scope : hint_range(0.1, 10.0) = 3.5;
uniform bool use_system_time = true;
uniform float time_accel : hint_range(0.0, 10.0) = 2.0;

// --- NEON PARAMS ---
uniform float speed         : hint_range(0.0, 2.0) = 1.0; 
uniform float glow_strength : hint_range(0.0, 3.0) = 0.7;
uniform float edge_softness : hint_range(0.0, 1.0) = 0.15;
uniform vec4  color : source_color = vec4(1.0, 0.3, 0.1, 1.0);

// --- VOID PARAMS (новое) ---
uniform float void_strength : hint_range(0.0, 2.0) = 1.2;
uniform float void_scale    : hint_range(0.5, 5.0) = 2.5;
uniform float void_power    : hint_range(1.0, 5.0) = 3.0;

// --- FBM PARAMS ---
uniform float noise_scale = 3.0;
uniform float roughness = 0.65;
uniform float lacunarity = 2.0;
uniform int detail = 3;

// -------- NOISE --------
float snoise(vec3 uv, float res)
{
    const vec3 s = vec3(1.0, 100.0, 1000.0);
    uv *= res;

    vec3 uv0 = floor(mod(uv, res));
    vec3 uv1 = floor(mod(uv + 1.0, res));

    vec3 f = fract(uv);
    f = f * f * (3.0 - 2.0 * f);

    vec3 base0 = uv0 * s;
    vec3 base1 = uv1 * s;

    vec4 v = vec4(
        base0.x + base0.y + base0.z,
        base1.x + base0.y + base0.z,
        base0.x + base1.y + base0.z,
        base1.x + base1.y + base0.z
    );

    vec4 r = fract(sin(v * 0.1) * 1000.0);
    float r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);

    r = fract(sin((v + base1.z - base0.z) * 0.1) * 1000.0);
    float r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);

    return mix(r0, r1, f.z) * 2.0 - 1.0;
}

// -------- FBM --------
vec2 random2(vec2 st) {
    return fract(sin(vec2(
        dot(st, vec2(127.1,311.7)),
        dot(st, vec2(269.5,183.3))
    )) * 43758.5453);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(
        mix(dot(random2(i), f),
            dot(random2(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
        mix(dot(random2(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
            dot(random2(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x),
        u.y
    );
}

float fbm(vec2 st) {
    float value = 0.0;
    float amp = 0.5;

    for (int i = 0; i < detail; i++) {
        value += amp * noise(st);
        st *= lacunarity;
        amp *= roughness;
    }

    return value * 0.5 + 0.5;
}

// -------- NEON --------
vec3 neon(float val, vec3 col) {
    float r = clamp(val, 0.0, 1.0);
    float r2 = r * r;
    float r3 = r2 * r;

    vec3 outp = pow(col, vec3(3.0)) * pow(r, 1.5);
    outp += col * r2;
    outp += vec3(1.2) * r3;

    return outp;
}

// -------- MAIN --------
void fragment() 
{
    vec2 p = UV * 2.0 - 1.0;
    float len_p = length(p);

    float t = use_system_time ? TIME * time_accel : time;

    // --- fire ---
    float fire = 3.0 - frame_scope * (2.0 * len_p);

    vec3 coord = vec3(
        atan(p.x, p.y) * 0.15915494 + 0.5,
        len_p * 0.4,
        0.5
    );

    vec3 time_offset = vec3(0.0, -t * 0.05, t * 0.01);

    for (int i = 1; i <= 6; i++) {
        float power = exp2(float(i));
        fire += (1.5 / power) * snoise(coord + time_offset, power * 16.0);
    }

    // --- fbm ---
    vec2 n_uv = p * noise_scale + vec2(t * speed, t * speed * 0.4);
    float n = fbm(n_uv);

    float edge = smoothstep(0.5, 0.5 - edge_softness, len_p);
    edge = pow(edge, 2.5);

    float energy = max(fire, 0.0) * edge;
    float glow = energy * glow_strength * (0.6 + n);

    // -------- VOID FLAMES --------
    vec2 void_uv = p * void_scale + vec2(-t * 0.3, t * 0.2);
    float void_noise = fbm(void_uv);

    float void_mask = pow(1.0 - void_noise, void_power);
    void_mask *= edge;
    void_mask *= void_strength;

    // "пожирание света"
    glow *= (1.0 - void_mask);

    // --- color ---
    vec3 base_col = color.rgb * (0.6 + n);
    vec3 final_col = neon(glow, base_col);

    // добавляем глубокую тьму
    final_col -= void_mask * 0.8;

    COLOR = vec4(final_col, glow);
}