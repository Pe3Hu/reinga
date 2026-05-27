shader_type canvas_item;

uniform sampler2D chars;

const vec2 GRID = vec2(18.0, 17.0);

// === НАСТРОЙКИ ===
uniform float columns = 40.0;

// цвета
uniform vec3 trail_color : source_color = vec3(0.1, 0.9, 0.2);
uniform vec3 head_color  : source_color = vec3(0.8, 1.0, 0.8);
uniform sampler2D mask_tex;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void fragment() {

	// колонка в UV-пространстве (без пикселей!)
	float cx = UV.x * columns;
	float col_id = floor(cx);
	float col_u = fract(cx);

	float col_n = hash(vec2(col_id, 0.0));

	float speed = mix(0.12, 0.28, col_n);
	float offset = col_n * 10.0;

	// ВАЖНО: фиксируем фазу по UV.y, НЕ по “пересчитанным пикселям”
	float y = UV.y + offset;
	float y_pos = y - TIME * speed;

	float trail = 1.0 - fract(y_pos);
	float trail_len = 0.25 + col_n * 0.25;

	float t = smoothstep(trail_len, 0.0, trail);
	float head = smoothstep(0.03, 0.0, trail);

	float head_intensity = head;
	float trail_intensity = t * (1.0 - head);

	// строки символов (НЕ завязываем на columns!)
	float py = UV.y * 32.0;
	float row = floor(py);

	float n = hash(vec2(col_id, row));
	float index = floor(n * (GRID.x * GRID.y));

	float x = mod(index, GRID.x);
	float y_cell = floor(index / GRID.x);

	float eps = 0.5 / max(GRID.x, GRID.y);

	vec2 uv_cell = vec2(col_u, fract(py));
	vec2 cell_uv_safe = mix(vec2(eps), vec2(1.0 - eps), uv_cell);

	vec2 atlas_uv = (vec2(x, y_cell) + cell_uv_safe) / GRID;

	vec3 base = texture(chars, atlas_uv).rgb;

	float mask = smoothstep(0.4, 0.6, base.r);

	vec3 col = mix(trail_color, head_color, head_intensity);
	col *= trail_intensity;
	col *= mask;

	float fade = smoothstep(1.0, 0.0, UV.y);
	col *= fade;
	
	float circle = mask * fade;
	COLOR = vec4(vec3(1.0), circle);

	float alpha = (trail_intensity + head_intensity) * mask * fade;

	COLOR.rgb = col;
	COLOR.a = alpha;
}