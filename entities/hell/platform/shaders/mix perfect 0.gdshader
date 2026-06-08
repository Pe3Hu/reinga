shader_type canvas_item;

uniform vec2 scene_size = vec2(200, 200);

#define plasticity 25.0
#define seed 70.4
#define noisesmooth 800.0
#define nComp 4.0
#define PI 3.14159

float rand(vec2 c){
	return fract(sin(dot(c.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p, float freq ){
	float unit = noisesmooth / freq;
	vec2 ij = floor(p / unit);
	vec2 xy = mod(p, unit) / unit;
	xy = 0.5 * (1.0 - cos(PI * xy));
	float a = rand(ij + vec2(0.0,0.0));
	float b = rand(ij + vec2(1.0,0.0));
	float c = rand(ij + vec2(0.0,1.0));
	float d = rand(ij + vec2(1.0,1.0));
	float x1 = mix(a, b, xy.x);
	float x2 = mix(c, d, xy.x);
	return mix(x1, x2, xy.y);
}

float pNoise(vec2 p, int res){
	float persistence = 0.5;
	float n = 0.0;
	float normK = 0.0;
	float f = 4.0;
	float amp = 1.0;
	int iCount = 0;
	for (int i = 0; i < 50; i++){
		n += amp * noise(p, f);
		f *= 2.0;
		normK += amp;
		amp *= persistence;
		if (iCount == res) break;
		iCount++;
	}
	float nf = n / normK;
	float rr = nf * nf * nf * nf;
	return pow(rr, 1.0 / nComp) * 2.0 - 1.0;
}

vec3 hsv2rgb(vec3 c){
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 CMYKtoRGB(vec3 cmyk){
	float c = cmyk.x;
	float m = cmyk.y;
	float y = cmyk.z;
	float k = 0.0;
	float invK = 1.0 - k;
	float r = 1.0 - min(1.0, c * invK + k);
	float g = 1.0 - min(1.0, m * invK + k);
	float b = 1.0 - min(1.0, y * invK + k);
	return clamp(vec3(r,g,b), 0.0, 1.0);
}

vec2 rotate(vec2 p, float t){
	float s = sin(t);
	float c = cos(t);
	mat2 m = mat2(vec2(c, -s), vec2(s, c));
	return m * p;
}

float sdfCircle(vec2 p, float r){
	return length(p) - r;
}

float sdfSquare(vec2 p, vec2 b){
	vec2 q = abs(p) - b;
	return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - 5.0;
}

vec2 trans(vec2 x, vec2 _scene_size){
	x.y = 1.0 - x.y;
	return x * _scene_size;
}

float mixShapeFactor(float x, float y, float attractiveness){
	float m = 0.5 + clamp((x - y) / attractiveness, -1.0, 1.0) / 2.0;
	return smoothstep(0.0, 1.0, m);
}

vec2 cellPos(vec2 id, vec2 cellSize){
	return (id + 0.5) * cellSize;
}

void fragment(){
	vec2 viewport = UV;
	vec2 pc = trans(viewport, scene_size);

	vec2 gridSize = vec2(3.0, 3.0);
	vec2 cellSize = scene_size / gridSize;

	vec2 sq1_id = vec2(0.0, 0.0);
	vec2 sq2_id = vec2(2.0, 2.0);

	vec2 sq1 = cellPos(sq1_id, cellSize);
	vec2 sq2 = cellPos(sq2_id, cellSize);

	float t = sin(TIME * 0.5) * 0.5 + 0.5;
	vec2 ball = mix(sq1, sq2, t);

	float sTime = seed + TIME;
	float scale = scene_size.x / 200.0;

	float x = sdfSquare(
		rotate(pc - sq1, sTime),
		vec2(15.0, 15.0) * scale
	);

	vec3 cmix = vec3(0.0, 0.0, 1.0);

	float y = sdfSquare(
		pc - sq2,
		vec2(20.0, 20.0) * scale
	);

	float f = mixShapeFactor(x, y, plasticity);
	float d = mix(x, y, f);
	cmix = mix(cmix, vec3(1.0, 0.0, 0.0), f);

	float y2 = sdfCircle(
		pc - ball,
		20.0 * scale
	);

	f = mixShapeFactor(d, y2, plasticity);
	d = mix(d, y2, f);
	cmix = mix(cmix, vec3(0.0, 1.0, 0.0), f);

	vec3 col = hsv2rgb(vec3((d / 25.0), 0.2, 1.0));
	col = mix(CMYKtoRGB(cmix), col, clamp(d, 0.0, 0.5));

	COLOR = vec4(col, 1.0);
}
