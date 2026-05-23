shader_type canvas_item;

vec2 hash(vec2 p) {
	p = vec2(dot(p, vec2(127.1, 311.7)),
	         dot(p, vec2(269.5, 183.3)));
	return fract(sin(p) * 43758.5453123) * 2.0 - 1.0;
}

// Gradient noise (Perlin-style)
float grad_noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);

	vec2 u = f * f * (3.0 - 2.0 * f);

	vec2 g00 = hash(i + vec2(0.0, 0.0));
	vec2 g10 = hash(i + vec2(1.0, 0.0));
	vec2 g01 = hash(i + vec2(0.0, 1.0));
	vec2 g11 = hash(i + vec2(1.0, 1.0));

	vec2 d00 = f - vec2(0.0, 0.0);
	vec2 d10 = f - vec2(1.0, 0.0);
	vec2 d01 = f - vec2(0.0, 1.0);
	vec2 d11 = f - vec2(1.0, 1.0);

	float v00 = dot(g00, d00);
	float v10 = dot(g10, d10);
	float v01 = dot(g01, d01);
	float v11 = dot(g11, d11);

	return mix(
		mix(v00, v10, u.x),
		mix(v01, v11, u.x),
		u.y
	);
}

float value(vec2 p) {
	return grad_noise(p);
}

void fragment()
{
	vec2 res = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 u = FRAGCOORD.xy / res;

	vec2 c = u * 3.0;

	vec2 h = vec2(0.0);
	float a = 1.0;
	float s = 1.0;

	for (int i = 0; i < 10; i++) {
		a *= 2.2;
		s *= 2.0;

		h += vec2(
			value(c * s + TIME * vec2(0.2, 0.1 * a) + h.x * a / s * vec2(4.0, 6.0)),
			1.0
		) / a;
	}

	float g = smoothstep(-0.8, 0.8, h.x / h.y - (1.0 - u.y));

	float n = 1.0 + 0.05 * g * g *
		cos(value(FRAGCOORD.xy * 0.2 + vec2(g, 0.0) * 10.0) / 0.1 + TIME / 0.1);

	vec3 col = exp(-vec3(2.0, 6.0, 11.0) * g) * n;

	COLOR = vec4(col, 1.0);
}