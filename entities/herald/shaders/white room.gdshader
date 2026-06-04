shader_type canvas_item;

#define ITE_MAX 15

vec2 rot(vec2 p, float a)
{
	float c = cos(a);
	float s = sin(a);
	return vec2(
		c * p.x - s * p.y,
		s * p.x + c * p.y
	);
}

vec3 tex(vec2 uv)
{
	vec3 c = fract(vec3(uv.x, uv.x, uv.y));

	if (mod(uv.x * 2.0, 2.0) < 0.9) return vec3(0.0);
	if (mod(uv.y * 1.0, 1.0) < 0.9) return vec3(0.0);

	return c;
}

void fragment()
{
	float M = -TIME * 0.5;
	float fog = 1.0;

	vec2 res = 1.0 / SCREEN_PIXEL_SIZE;

	vec2 uv = (FRAGCOORD.xy / res) * 2.0 - 1.0;
	uv *= vec2(res.x / res.y, 1.0);

	uv = rot(uv, 0.0);

	vec3 c = vec3(0.0);

	for (int i = 0; i < ITE_MAX; i++)
	{
		vec2 suv = uv;

		float y = abs(suv.y);

		c = tex(vec2(
			suv.x / abs(y / float(i + 1)) + M,
			abs(y)
		));

		if (length(c) > 0.5)
			break;

		uv = uv.yx * 1.3;
		fog *= 0.9;
	}

	float g = fog * fog;
	float intensity = c.x;

	vec3 colrgb = vec3(
		intensity * 0.12 * g,
		intensity * g,
		intensity * g
	);

	vec4 col = vec4(1.0 - colrgb, 1.0);

	COLOR = col;
}