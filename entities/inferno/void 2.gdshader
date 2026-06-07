shader_type canvas_item;

uniform sampler2D portal_texture : source_color, filter_linear_mipmap_anisotropic;

uniform vec4 portal_tint : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float vortex_effect_radius : hint_range(0.01, 1.0, 0.01) = 1.0;
uniform float twist_strength : hint_range(0.0, 30.0, 0.1) = 3.5;

uniform float overall_rotation_speed : hint_range(0.0, 2.0, 0.01) = 0.25;

uniform float texture_scroll_speed_x : hint_range(-1.0, 1.0, 0.01) = 0.0;
uniform float texture_scroll_speed_y : hint_range(-1.0, 1.0, 0.01) = 0.0;

uniform float edge_softness : hint_range(0.01, 0.5, 0.005) = 0.3;

mat2 rotate(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat2(vec2(c, -s), vec2(s, c));
}

void fragment() {
    vec2 uv = UV - 0.5;

    vec2 aspect = TEXTURE_PIXEL_SIZE;
    if (aspect.x > aspect.y) {
        uv.x *= aspect.x / aspect.y;
    } else {
        uv.y *= aspect.y / aspect.x;
    }

    uv = rotate(TIME * overall_rotation_speed) * uv;

    float dist = length(uv);
    dist = max(dist, 0.001);

    float t = clamp(dist / vortex_effect_radius, 0.0, 1.0);
    float twist_factor = (1.0 - t);
    twist_factor *= twist_factor;

    float twist_angle = twist_factor * twist_strength;

    if (dist < vortex_effect_radius) {
        uv = rotate(twist_angle) * uv;
    }

    vec2 scroll = TIME * vec2(texture_scroll_speed_x, texture_scroll_speed_y);
    vec2 final_uv = uv + scroll;

    if (aspect.x > aspect.y) {
        final_uv.x /= aspect.x / aspect.y;
    } else {
        final_uv.y /= aspect.y / aspect.x;
    }

    final_uv += 0.5;

    vec4 tex = texture(portal_texture, final_uv);

    float outer_fade = smoothstep(
        vortex_effect_radius,
        vortex_effect_radius - edge_softness,
        dist
    );

    float alpha = outer_fade;

    COLOR = tex * portal_tint;
    COLOR.a *= alpha;
}