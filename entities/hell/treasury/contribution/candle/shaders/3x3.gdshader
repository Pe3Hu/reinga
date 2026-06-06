shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float size = 1.1;
uniform float edge = 3.0;
uniform float speed = 0.1;

uniform int active_sector = 0;
uniform float inactive_strength = 0.25;

uniform float blur_strength = 2.5;
uniform float refraction = 0.01;

const vec2 GRID = vec2(3.0, 3.0);

uniform float seed = 0.0;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

// HSV → RGB
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

// frosted blur
vec3 sample_blur(vec2 uv) {

    vec2 off = vec2(blur_strength * 0.003);

    vec3 col = vec3(0.0);
    col += texture(SCREEN_TEXTURE, uv + off).rgb;
    col += texture(SCREEN_TEXTURE, uv - off).rgb;
    col += texture(SCREEN_TEXTURE, uv + vec2(off.x, -off.y)).rgb;
    col += texture(SCREEN_TEXTURE, uv + vec2(-off.x, off.y)).rgb;

    return col * 0.25;
}

void fragment() {
    vec2 uv = UV;

    vec2 grid_uv = uv * GRID;
    vec2 cell_id = floor(grid_uv);
    vec2 f = fract(grid_uv);

    vec2 p = f * 2.0 - 1.0;

    float dist = dot(p, p);

    int id = int(cell_id.y) * 3 + int(cell_id.x);

    float t = TIME * speed + seed;
    float rn = random(cell_id);

    float pulse = 0.5 + 0.5 * sin(t + rn * 6.2831);

    float shape = 1.0 - smoothstep(0.0, 1.0, pow(dist * size, edge));

    vec2 refract_uv = SCREEN_UV + (p * refraction) * shape;

    vec3 bg = sample_blur(refract_uv);

    vec3 glass_tint = mix(bg, vec3(0.78, 0.82, 0.88), 0.35);

    float glow = exp(-dist * 4.0);

    vec3 color;

    if (id == active_sector) {
        float hue = fract(t * 0.15 + float(id) * 0.11);
        vec3 hsv = vec3(hue, 1.0, 1.0);
        color = hsv2rgb(hsv);

        color = mix(glass_tint, color, 0.75);
        color += glow * 0.4;
    } else {
        color = glass_tint;
        color += vec3(0.03, 0.04, 0.05) * glow;
    }

    float alpha = shape * (0.6 + 0.4 * pulse);
    alpha *= smoothstep(1.2, 0.2, dist);

    COLOR = vec4(color, alpha);
}