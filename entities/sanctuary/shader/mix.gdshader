shader_type canvas_item;

uniform sampler2D chars;

const vec2 GRID = vec2(18.0, 17.0);

// настройки матрицы
uniform float columns = 40.0;

// цвета
uniform vec3 trail_color : source_color = vec3(0.1, 0.9, 0.2);
uniform vec3 head_color  : source_color = vec3(0.8, 1.0, 0.8);

// форма круга
uniform vec2 circle_center = vec2(0.5, 0.5);
uniform float circle_radius = 0.35;
uniform float edge_softness = 0.03;

// шум края (делает "рваный круг")
float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void fragment() {

	// =========================
	// MATRIX LOGIC (как у тебя)
	// =========================

	float cx = UV.x * columns;
	float col_id = floor(cx);
	float col_u = fract(cx);

	float col_n = hash(vec2(col_id, 0.0));

	float speed = mix(0.12, 0.28, col_n);
	float offset = col_n * 10.0;

	float y = UV.y + offset;
	float y_pos = y - TIME * speed;

	float trail = 1.0 - fract(y_pos);
	float trail_len = 0.25 + col_n * 0.25;

	float t = smoothstep(trail_len, 0.0, trail);
	float head = smoothstep(0.03, 0.0, trail);

	float head_intensity = head;
	float trail_intensity = t * (1.0 - head);

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

	float alpha = (trail_intensity + head_intensity) * mask * fade;

	// =========================
	// CIRCLE MASK (НОВАЯ ЧАСТЬ)
	// =========================

	// расстояние до центра
	float dist = distance(UV, circle_center);

	// лёгкий "рваный" край
	float wobble = (hash(UV * 30.0) - 0.5) * 0.02;

	float radius = circle_radius + wobble;

	float circle_mask = smoothstep(radius, radius - edge_softness, dist);

	// =========================
	// APPLY MASK
	// =========================

	col *= circle_mask;
	alpha *= circle_mask;

	COLOR.rgb = col;
	COLOR.a = alpha;
}