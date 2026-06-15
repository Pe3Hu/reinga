shader_type canvas_item;


const float side = 0.3;
const float angle = PI*1.0/3.0;
const float sinA = 0.86602540378;
const float cosA = 0.5;
const vec3 zero = vec3(0.0);
const vec3 one = vec3(1.0);

// generates the colors for the rays in the background
vec4 rayColor(vec2 fragToCenterPos, vec2 fragCoord) {
	float d = length(fragToCenterPos);
	fragToCenterPos = normalize(fragToCenterPos);
		
	float multiplier = 0.0;
	const float loop = 60.0;
	const float dotTreshold = 0.90;
	const float timeScale = 0.75;
	const float fstep = 10.0;
	
	float c = 0.5/(d*d);
	float freq = 0.25;		
	for (float i = 1.0; i < loop; i++) {
		float attn = c;
		attn *= 1.85*(sin(i*0.3*TIME)*0.5+0.5);
		float t = TIME*timeScale - fstep*i;
		vec2 dir = vec2(cos(freq*t), sin(freq*t));
		float m = dot(dir, fragToCenterPos);
		m = pow(abs(m), 4.0);
		m *= float((m) > dotTreshold);
		multiplier += 0.5*attn*m/(i);
	}

	const float r0 = 0.345;
	const float r1 = r0 + 0.02;
	const float r2 = r1 + 0.005;
	
	float f = 1.0;

	const vec4 rayColorVec = vec4(0.9, 0.7, 0.3, 1.0);
		
	float pat = abs(sin(10.0*mod(fragCoord.y*fragCoord.x, 1.5)));
	f += pat;
	vec4 color = f*multiplier*rayColorVec;
	return color;
}

void fragment() {
    vec2 fragCoord = FRAGCOORD.xy;
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	
	float aspect = iResolution.x / iResolution.y;	
	vec3 pos = vec3(fragCoord.xy / iResolution.xy, 1.0);
	pos.x *= aspect;
	
	vec2 fragToCenterPos = vec2(pos.x - 0.5*aspect, pos.y - 0.5);
	vec4 rayCol = rayColor(fragToCenterPos, fragCoord);
	
	float u = 0.0;
	float v = 0.0;
	float w = 0.0;
	//float c = insideTriforce(pos, aspect, u, v, w);	

	float lim = 0.075;
	
	vec3 normal = vec3(0.0, 0.0, 1.0);
	vec3 uNormalContrib = vec3(0.0);
	vec3 vNormalContrib = vec3(0.0);
	vec3 wNormalContrib = vec3(0.0);
		
	if (u < lim) {
		float uNorm = u/lim;
		float offset = cos(0.5*PI*uNorm);
		offset *= offset;
		uNormalContrib = vec3(0.0, -offset, 0.0);
	}
	if (v < lim) {
		float vNorm = v/lim;
		float offset = -cos(0.5*PI*vNorm);
		offset *= offset;
		vNormalContrib = vec3(offset*cosA, offset*sinA, 0.0);
	}
	if (w < lim) {
		float wNorm = w/lim;
		float offset = cos(0.5*PI*wNorm);
		offset *= offset;
		wNormalContrib = vec3(-offset*cosA, offset*sinA, 0.0);
	}
	
	normal += uNormalContrib + vNormalContrib + wNormalContrib;
	normal = normalize(normal);
	
	float freq = 1.5*TIME;
	vec3 view = vec3(0.5, 0.5, 0.0) + vec3(sin(freq), cos(freq), 2.0);
	view = normalize(view);
	
	float light = dot(view, normal);
	
	float minW = mod(1.15*TIME, 4.0);
	float maxW = minW + 0.3;
	float s = 1.0;
	if (w > minW && w < maxW)
		s += 0.1;

	COLOR = rayCol;
}
