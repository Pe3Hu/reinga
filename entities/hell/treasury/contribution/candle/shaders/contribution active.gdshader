shader_type canvas_item;

uniform float speed = 2.0;
uniform float frequency = 10.0;   // количество кругов
uniform float softness = 3.0;     // мягкость переходов
uniform float alpha_strength = 1.0;

void fragment() {
    vec2 uv = UV - vec2(0.5);

    float dist = length(uv);

    // создаём расходящиеся круги
    float waves = sin((dist * frequency - TIME * speed) * 6.28318);

    // переводим синус в 0..1
    waves = waves * 0.5 + 0.5;

    // делаем более "кольцевой" контраст
    float gray = smoothstep(0.0, 1.0, pow(waves, softness));

    // можно слегка приглушить центр или наоборот усилить
    gray = mix(0.2, 0.8, gray);

    // прозрачность: слабее на тёмных участках
    float alpha = gray * alpha_strength;

    COLOR = vec4(vec3(gray), alpha);
}