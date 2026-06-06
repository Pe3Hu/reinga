shader_type canvas_item;

uniform vec4 color: source_color = vec4(1.0);
uniform float direction: hint_range(-1.0, 1.0, 1.0) = -1.0;
uniform float frequency: hint_range(0.1, 30.0, 0.1) = 15.0;
uniform float speed: hint_range(0.5, 20, 0.5) = 3.0;
uniform float radius: hint_range(0.01, 1.0, 0.01) = 1.0;
uniform float line_thickness: hint_range(0.0, 0.5, 0.01) = 0.06;

uniform vec2 rect_size = vec2(1.0, 10.0);

void fragment() {

    vec2 uv = UV - vec2(0.5);

    // 🔥 компенсация растяжения прямоугольника
    uv.y *= rect_size.y / rect_size.x;

    vec4 circle_outline;

    float circle = step(length(uv), radius);

    float angle = atan(uv.y, uv.x);

    float wave = 0.5 * sin(direction * frequency * angle + TIME * speed) + 0.5;

    circle *= step(0.5, wave);

    circle_outline = vec4(color.rgb, circle * color.a);

    float rect_alpha =
        1.0 - step(abs(uv.x), (0.5 - line_thickness))
            * step(abs(uv.y), (0.5 - line_thickness));

    COLOR = circle_outline * vec4(1.0, 1.0, 1.0, rect_alpha);
}