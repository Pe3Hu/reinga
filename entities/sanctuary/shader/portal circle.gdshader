shader_type canvas_item;

uniform sampler2D textureNoise: repeat_enable;
uniform float radius: hint_range(0.0, 1.0) = 0.15;
uniform float effectControl: hint_range(0.0, 1.0) = 0.45;
uniform float burnSpeed: hint_range(0.0, 1.0) = 0.25;
uniform float shape: hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec2 centerDistVec = vec2(0.5) - UV;
    
    float distToCircleEdge = length(centerDistVec);
    float distToSquareEdge = max(abs(centerDistVec.x), abs(centerDistVec.y));
	float distToEdge = mix(distToCircleEdge,distToSquareEdge,shape);

    float gradient = smoothstep(0.5, 0.5 - radius, distToEdge);

    vec2 direction = vec2(0, 1) * burnSpeed;
    float noiseValue = texture(textureNoise, UV + direction * TIME).r;

    float opacity = step(radius, mix(gradient, noiseValue, effectControl) - distToEdge);

    COLOR = texture(TEXTURE, UV) * vec4(1.0, 1.0, 1.0, opacity);
}
