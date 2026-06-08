shader_type canvas_item;

uniform vec2 scene_size = vec2(200, 200);

uniform int cell_state_00 = 0;
uniform int cell_state_10 = 0;
uniform int cell_state_20 = 0;
uniform int cell_state_01 = 0;
uniform int cell_state_11 = 0;
uniform int cell_state_21 = 0;
uniform int cell_state_02 = 0;
uniform int cell_state_12 = 0;
uniform int cell_state_22 = 0;

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

vec2 cellPos(vec2 id, vec2 cellSize){
	return (id + 0.5) * cellSize;
}

int getCellState(vec2 id){
	if(id == vec2(0.0, 0.0)) return cell_state_00;
	if(id == vec2(1.0, 0.0)) return cell_state_10;
	if(id == vec2(2.0, 0.0)) return cell_state_20;
	if(id == vec2(0.0, 1.0)) return cell_state_01;
	if(id == vec2(1.0, 1.0)) return cell_state_11;
	if(id == vec2(2.0, 1.0)) return cell_state_21;
	if(id == vec2(0.0, 2.0)) return cell_state_02;
	if(id == vec2(1.0, 2.0)) return cell_state_12;
	if(id == vec2(2.0, 2.0)) return cell_state_22;
	return 0;
}

float getCellRotationSpeed(vec2 id){
	return rand(id) * 0.3 + 0.05;
}

float getBallSpeedMultiplier(vec2 cell1Id, vec2 cell2Id){
	vec2 seed_val = cell1Id + cell2Id * 0.3;
	return rand(seed_val) * 0.2 + 0.9;
}

float getBallTimeOffset(vec2 cell1Id, vec2 cell2Id){
	vec2 seed_val = cell1Id + cell2Id * 0.5;
	return rand(seed_val) * 2.0 * PI;
}

float getBallPulseSpeed(vec2 cell1Id, vec2 cell2Id){
	vec2 seed_val = cell1Id + cell2Id * 0.7;
	return rand(seed_val) * 1.0 + 0.5;
}

void getCellSquare(vec2 cellId, vec2 pc, vec2 cellSize, float scale, float sTime, 
					out float sdf, out vec3 color, out float rotation){
	int state = getCellState(cellId);
	vec2 cellCenter = cellPos(cellId, cellSize);
	
	if(state == 0){
		float rotSpeed = getCellRotationSpeed(cellId);
		float cellRotation = rotSpeed * sTime;
		sdf = sdfSquare(rotate(pc - cellCenter, cellRotation), vec2(15.0, 15.0) * scale);
		color = vec3(0.3, 0.3, 0.3);
		rotation = cellRotation;
	}
	else if(state == 1){
		sdf = sdfSquare(pc - cellCenter, vec2(15.0, 15.0) * scale);
		color = vec3(1.0, 1.0, 1.0);
		rotation = 0.0;
	}
	else{
		sdf = sdfSquare(rotate(pc - cellCenter, sTime), vec2(15.0, 15.0) * scale);
		color = vec3(0.0, 0.0, 0.0);
		rotation = sTime;
	}
}

float getNeighborBall(vec2 cell1Id, vec2 cell2Id, vec2 pc, vec2 cellSize, float scl, float globalTime){
	int state1 = getCellState(cell1Id);
	int state2 = getCellState(cell2Id);
	
	if(state1 != 0 && state2 != 0){
		vec2 pos1 = cellPos(cell1Id, cellSize);
		vec2 pos2 = cellPos(cell2Id, cellSize);
		
		vec2 direction = normalize(pos2 - pos1);
		
		float halfSide = 22.5 * scl;
		
		vec2 startPos = pos1 + direction * halfSide;
		vec2 endPos = pos2 - direction * halfSide;
		
		float speedMult = getBallSpeedMultiplier(cell1Id, cell2Id);
		float timeOffset = getBallTimeOffset(cell1Id, cell2Id);
		float adjustedTime = globalTime * speedMult + timeOffset;
		
		float t = sin(adjustedTime * 0.5) * 0.5 + 0.5;
		
		vec2 ballPos = mix(startPos, endPos, t);
		
		float pulseSpeed = getBallPulseSpeed(cell1Id, cell2Id);
		float pulseTime = globalTime * pulseSpeed + timeOffset;
		float pulseFactor = sin(pulseTime) * 0.5 + 0.5;
		
		float maxRadius = 18.0 * scl;
		float minRadius = 15.0 * scl;
		float radius = mix(minRadius, maxRadius, pulseFactor);
		
		return sdfCircle(pc - ballPos, radius);
	}
	
	return 1e10;
}

void fragment(){
	vec2 viewport = UV;
	vec2 pc = trans(viewport, scene_size);

	vec2 gridSize = vec2(3.0, 3.0);
	vec2 cellSize = scene_size / gridSize;

	float sTime = seed + TIME;
	float scale = scene_size.x / 200.0;

	float minDist = 1e10;
	vec3 finalColor = vec3(0.0);

	for(int y = 0; y < 3; y++){
		for(int x = 0; x < 3; x++){
			vec2 cellId = vec2(float(x), float(y));
			
			float cellSdf;
			vec3 cellColor;
			float rotation;
			getCellSquare(cellId, pc, cellSize, scale, sTime, cellSdf, cellColor, rotation);
			
			if(cellSdf < minDist){
				minDist = cellSdf;
				finalColor = cellColor;
			}
		}
	}

	for(int y = 0; y < 3; y++){
		for(int x = 0; x < 2; x++){
			vec2 cell1 = vec2(float(x), float(y));
			vec2 cell2 = vec2(float(x + 1), float(y));
			float ballSdf = getNeighborBall(cell1, cell2, pc, cellSize, scale, TIME);
			if(ballSdf < minDist){
				minDist = ballSdf;
				finalColor = vec3(0.66, 0.66, 0.66);
			}
		}
	}

	for(int x = 0; x < 3; x++){
		for(int y = 0; y < 2; y++){
			vec2 cell1 = vec2(float(x), float(y));
			vec2 cell2 = vec2(float(x), float(y + 1));
			float ballSdf = getNeighborBall(cell1, cell2, pc, cellSize, scale, TIME);
			if(ballSdf < minDist){
				minDist = ballSdf;
				finalColor = vec3(0.66, 0.66, 0.66);
			}
		}
	}

	float grayValue = 0.5 + clamp(minDist / 50.0, -0.5, 0.5);
	vec3 col = vec3(grayValue);
	col = mix(finalColor, col, clamp(minDist, 0.0, 0.5));

	COLOR = vec4(col, 1.0);
}
