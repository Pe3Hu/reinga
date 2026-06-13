shader_type canvas_item;

uniform float time_scale = 1.0;
uniform float glow_intensity = 1.0;
uniform float fade_top = 0.7;  // высота начала затухания (0-1, где 1 = верх)
uniform float fade_smoothness = 1.0;  // мягкость перехода

float noise(vec3 p)
{
	vec3 i = floor(p);
	vec4 a = dot(i, vec3(1., 57., 21.)) + vec4(0., 57., 21., 78.);
	vec3 f = cos((p-i)*acos(-1.))*(-.5)+.5;
	a = mix(sin(cos(a)*a),sin(cos(1.+a)*(1.+a)), f.x);
	a.xy = mix(a.xz, a.yw, f.y);
	return mix(a.x, a.y, f.z);
}

float sphere(vec3 p, vec4 spr)
{
	return length(spr.xyz-p) - spr.w;
}

float flame(vec3 p)
{
	float d = sphere(p*vec3(1.,.5,1.), vec4(.0,-1.,.0,1.));
	return d + (noise(p+vec3(.0,TIME*2.0*time_scale,.0)) + noise(p*3.)*.5)*.25*(p.y);
}

float scene(vec3 p)
{
	return min(100.-length(p), abs(flame(p)));
}

vec4 raymarch(vec3 org, vec3 dir)
{
	float d = 0.0, glow = 0.0, eps = 0.02;
	vec3 p = org;
	bool glowed = false;
	
	for(int i=0; i<64; i++)
	{
		d = scene(p) + eps;
		p += d * dir;
		if(d > eps)
		{
			if(flame(p) < .0)
				glowed = true;
			if(glowed)
       			glow = float(i)/64.;
		}
	}
	return vec4(p, glow);
}

void fragment()
{
	vec2 v = UV * 2.0 - 1.0;
	v.y = -v.y;
	v.x *= 1.0 / SCREEN_PIXEL_SIZE.y * SCREEN_PIXEL_SIZE.x;

	vec3 org = vec3(0., -2., 4.);
	vec3 dir = normalize(vec3(v.x * 1.6, -v.y, -1.5));

	vec4 p = raymarch(org, dir);
	float glow = p.w;

	vec4 col = mix(vec4(1., .5, .1, 1.), vec4(0.1, .5, 1., 1.), p.y * .02 + .4);

	// Плавное затухание в верхней части (UV.y=1 вверху, UV.y=0 внизу)
	float fade = smoothstep(fade_top - fade_smoothness, fade_top, UV.y);
	float final_glow = glow * fade;

	COLOR = mix(vec4(0.), col, pow(final_glow * 2.0 * glow_intensity, 4.));
}
