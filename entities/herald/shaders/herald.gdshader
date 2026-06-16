shader_type canvas_item;

const float side = 0.3;
const float angle = PI*1.0/3.0;
const float sinA = 0.86602540378;
const float cosA = 0.5;

const float LOOP = 60.0;
const float DOT_TRESHOLD = 0.90;
const float TIME_SCALE = 0.75;
const float FSTEP = 10.0;
const float FREQ = 0.25;

const float R0 = 0.345;
const float R1 = R0 + 0.02;
const float R2 = R1 + 0.005;
uniform vec3 final_color : source_color = vec3(0.9, 0.7, 0.3);
uniform bool invert = false;

const float PAT_FREQ = 10.0;
const float PAT_MOD = 1.5;
const float LIM = 0.075;
const float PI_HALF = PI * 0.5;

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec4 rayColor(vec2 fragToCenterPos, vec2 fragCoord) {
	float d = length(fragToCenterPos);
	fragToCenterPos = normalize(fragToCenterPos);
	
	float multiplier = 0.0;
	float c = 0.5/(d*d);
	float timeBase = TIME * TIME_SCALE;
	
	for (float i = 1.0; i < LOOP; i++) {
		float attn = c * 1.85 * (sin(i*0.3*TIME)*0.5+0.5);
		float t = timeBase - FSTEP*i;
		
		vec2 dir = vec2(cos(FREQ*t), sin(FREQ*t));
		float m = dot(dir, fragToCenterPos);
		m = pow(abs(m), 4.0);
		
		if (m > DOT_TRESHOLD) {
			multiplier += 0.5 * attn * m / i;
		}
	}

	float pat = abs(sin(PAT_FREQ*mod(fragCoord.y*fragCoord.x, PAT_MOD)));
	float f = 1.0 + pat;
	
	return f * multiplier * vec4(final_color, 1.0);
}

void fragment() {
    vec2 fragCoord = FRAGCOORD.xy;
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	
	float aspect = iResolution.x / iResolution.y;	
	vec2 fragToCenterPos = vec2(fragCoord.x / iResolution.x - 0.5, 
	                             fragCoord.y / iResolution.y - 0.5);
	fragToCenterPos.x *= aspect;
	
	vec4 rayCol = rayColor(fragToCenterPos, fragCoord);
	
	COLOR = vec4(0.0, 0.0, 0.0, 1.0) + rayCol;
	
	if (invert) {
		vec3 hsv = rgb2hsv(COLOR.rgb);
		hsv.z = 1.0 - hsv.z;
		COLOR.rgb = hsv2rgb(hsv);
	}
}
