shader_type canvas_item;

uniform sampler2D noise_texture;

uniform int layers : hint_range(1, 64, 1) = 8;
uniform float depth_amount = 1.0;
uniform float fade_amount : hint_range(0.0, 16.0) = 1.0;

uniform vec2 parallax_strength = vec2(0.15, 0.15);
uniform vec2 parallax_origin = vec2(0.5, 0.5);

float overlay(float a, float b) {
    float m = step(0.5, a);
    return mix(
        2.0 * a * b,
        1.0 - 2.0 * (1.0 - a) * (1.0 - b),
        m
    );
}

// более "3D-похожий" псевдо-параллакс
vec2 parallax(vec2 uv, float depth) {
    vec2 dir = uv - parallax_origin;

    // имитация перспективного деления (как view.z в 3D)
    float z = 1.0 + depth * 2.0;

    return (dir * parallax_strength * depth) / z;
}

void fragment() {
    float value = 0.0;

    vec2 base_uv = UV;

    for (int i = 0; i < 64; i++) {
        if (i >= layers) break;

        float t = float(i) / float(layers);
        float depth = t * depth_amount;

        vec2 uv = base_uv + parallax(base_uv, depth);

        // важно: сохраняем ЛОГИКУ spatial версии (круг в "искажённом" пространстве)
        vec2 circle_uv = uv;
        float circle = length(circle_uv * 2.0 - 1.0);
        circle = clamp((circle - 0.2) / 0.8, 0.0, 1.0);

        // шум тоже должен идти через тот же UV
        vec2 noise_uv = uv;

        // вместо polar-искажения из spatial даём лёгкую "закрутку"
        noise_uv = (noise_uv - 0.5) * 1.2 + 0.5;

        noise_uv += vec2(TIME * 0.05, TIME * 0.03);
        noise_uv += t * 7.0;

        noise_uv = fract(noise_uv);

        float noise = texture(noise_texture, noise_uv).r;

        float layer_value = overlay(circle, noise);
        layer_value = step(0.5, layer_value);

        layer_value *= pow(1.0 - t, fade_amount);

        value = max(value, layer_value);
    }

    COLOR = vec4(vec3(value), 1.0);
}