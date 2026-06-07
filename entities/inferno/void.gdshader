shader_type canvas_item;

uniform sampler2D portal_texture : source_color, filter_linear_mipmap_anisotropic;

uniform vec4 portal_tint : source_color = vec4(1.0);

uniform float vortex_effect_radius : hint_range(0.01, 1.0) = 1.0;
uniform float twist_strength : hint_range(0.0, 30.0) = 3.5;
uniform float overall_rotation_speed : hint_range(0.0, 2.0) = 0.25;

uniform vec2 texture_scroll_speed = vec2(0.0);

uniform float edge_softness : hint_range(0.01, 0.5) = 0.3;

mat2 rotate(float a) {
    float s = sin(a), c = cos(a);
    return mat2(vec2(c, -s), vec2(s, c));
}

void fragment() {
    vec2 uv = UV - 0.5;

    vec2 aspect = TEXTURE_PIXEL_SIZE;
    vec2 scale = (aspect.x > aspect.y)
        ? vec2(aspect.x / aspect.y, 1.0)
        : vec2(1.0, aspect.y / aspect.x);

    uv *= scale;

    uv = rotate(TIME * overall_rotation_speed) * uv;

    float dist = max(length(uv), 0.001);

    float t = clamp(dist / vortex_effect_radius, 0.0, 1.0);
    float twist = (1.0 - t);
    twist *= twist * twist_strength;

    uv = rotate(twist * step(dist, vortex_effect_radius)) * uv;

    vec2 final_uv = uv + TIME * texture_scroll_speed;

    final_uv /= scale;
    final_uv += 0.5;

    vec4 tex = texture(portal_texture, final_uv);

    float alpha = smoothstep(
        vortex_effect_radius,
        vortex_effect_radius - edge_softness,
        dist
    );

    COLOR = tex * portal_tint;
    COLOR.a *= alpha;
}