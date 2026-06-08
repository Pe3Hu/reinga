shader_type canvas_item;

uniform float strength: hint_range(0., 1.) = 0.75;
uniform float speed: hint_range(0., 10.) = 0.35;
uniform float angle: hint_range(0., 360.) = 45.0;
uniform bool rotate_hue = false;

vec3 hsv_to_rgb(float hue, float saturation, float value) {
	vec3 c = vec3(hue, saturation, value);
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	float hue;
	
	if (rotate_hue) {
		// Базовый угол + динамическое вращение
		float rotation_angle = angle - TIME * speed * 90.0;
		
		// Применяем вращение направления градиента
		hue = -UV.x * cos(radians(rotation_angle)) - UV.y * sin(radians(rotation_angle));
	} else {
		// Движение справа на лево с фиксированным углом наклона
		float rotation_angle = angle;
		hue = -UV.x * cos(radians(rotation_angle)) - UV.y * sin(radians(rotation_angle)) + TIME * speed;
	}
	
	hue = fract(hue);
	
	// Конвертируем HSV в RGB с полной насыщенностью и яркостью
	vec3 rainbow = hsv_to_rgb(hue, 1.0, 1.0);
	
	vec4 color = texture(TEXTURE, UV);
	COLOR = mix(color, vec4(rainbow, color.a), strength);
}
