shader_type canvas_item;

// --- Поворот направления градиента ---
uniform int direction_mode = 1; 
// 1 = 60°, 2 = 180°, 3 = 300°


// --- Цвета градиента ---
uniform vec4 top_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 bottom_color : source_color = vec4(1.0, 1.0, 1.0, 0.0);

// --- мягкость перехода ---
uniform float fade_power = 1.5;

float get_angle() {
    if (direction_mode == 1) return radians(60.0);
    if (direction_mode == 2) return radians(180.0);
    return radians(300.0);
}

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // центрируем UV
    vec2 centered = UV - vec2(0.5);

    // поворот
    float angle = get_angle();
    mat2 rot = mat2(
        vec2(cos(angle), -sin(angle)),
        vec2(sin(angle),  cos(angle))
    );

    vec2 rotated = rot * centered;

    // нормализуем в диапазон 0..1 (как "высоту градиента")
    float grad = rotated.y + 0.5;

    // градиент с усилением
    grad = clamp(grad, 0.0, 1.0);
    grad = pow(1.0 - grad, fade_power);

    // цветовой градиент
    vec4 gradient_color = mix(bottom_color, top_color, grad);

    // итог: текстура × цвет градиента
    vec4 final_color = tex * gradient_color;

    COLOR = final_color;
}