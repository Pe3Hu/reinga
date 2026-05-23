shader_type canvas_item;

uniform float speed_x = 0.7;
uniform float speed_y = 0.4;
uniform float shift = 1.6;

vec2 hash(vec2 p) {
    p = vec2(
        dot(p, vec2(127.1, 311.7)),
        dot(p, vec2(269.5, 183.3))
    );
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    vec2 u = f * f * (3.0 - 2.0 * f);

    float a = dot(hash(i), f);
    float b = dot(hash(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0));
    float c = dot(hash(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0));
    float d = dot(hash(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0));

    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;

    mat2 m = mat2(
	    vec2(1.6, 1.2),
	    vec2(-1.2, 1.6)
	);

    for (int i = 0; i < 5; i++) {
        v += a * noise(p);
        p = m * p;
        a *= 0.5;
    }

    return v;
}

void fragment() {
    vec2 res = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 uv = SCREEN_UV * res;

    vec3 c1 = vec3(0.5, 0.0, 0.1);
    vec3 c2 = vec3(0.9, 0.0, 0.0);
    vec3 c3 = vec3(0.2, 0.0, 0.0);
    vec3 c4 = vec3(1.0, 0.9, 0.0);
    vec3 c5 = vec3(0.1);
    vec3 c6 = vec3(0.9);

    vec2 p = uv * 0.02;

    float q = fbm(p - TIME * 0.1);

    vec2 r = vec2(
        fbm(p + q + TIME * speed_x),
        fbm(p + q - TIME * speed_y)
    );

    vec3 col =
        mix(c1, c2, fbm(p + r)) +
        mix(c3, c4, r.x) -
        mix(c5, c6, r.y);

    float vignette = cos(shift * uv.y / res.y);

    COLOR = vec4(col * vignette, 1.0);
}