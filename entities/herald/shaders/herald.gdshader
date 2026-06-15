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

const float PAT_FREQ = 10.0;
const float PAT_MOD = 1.5;
const float LIM = 0.075;
const float PI_HALF = PI * 0.5;

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
}
