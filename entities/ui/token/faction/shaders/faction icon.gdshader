shader_type canvas_item;

// --- Режим направления ---
uniform int direction_mode = 1; 
// 1 = 60°, 2 = 180°, 3 = 300°, 0 = radial center

// --- Цвета ---
uniform vec4 top_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 bottom_color : source_color = vec4(1.0, 1.0, 1.0, 0.0);

// --- мягкость ---
uniform float fade_power = 1.5;

float get_angle() {
    if (direction_mode == 1) return radians(60.0);
    if (direction_mode == 2) return radians(180.0);
    return radians(300.0);
}

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    float grad;

    if (direction_mode == 0) {
        // --- РАДИАЛЬНЫЙ ГРАДИЕНТ ---
        vec2 centered = UV - vec2(0.5);

        // нормализуем расстояние: 0 в центре → 1 в углах
        float dist = length(centered) / 0.70710678;

        dist = clamp(dist, 0.0, 1.0);

        // центр = 1, края = 0
        grad = pow(1.0 - dist, fade_power);

    } else {
        // --- ЛИНЕЙНЫЙ ГРАДИЕНТ ---
        vec2 centered = UV - vec2(0.5);

        float angle = get_angle();
        mat2 rot = mat2(
            vec2(cos(angle), -sin(angle)),
            vec2(sin(angle),  cos(angle))
        );

        vec2 rotated = rot * centered;

        grad = rotated.y + 0.5;
        grad = clamp(grad, 0.0, 1.0);

        // инверсия + мягкость
        grad = pow(1.0 - grad, fade_power);
    }

    // --- смешивание цветов ---
    vec4 gradient_color = mix(bottom_color, top_color, grad);

    // --- итог ---
    COLOR = tex * gradient_color;
}