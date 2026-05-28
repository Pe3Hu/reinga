shader_type canvas_item;

uniform sampler2D textureNoise: repeat_enable;
uniform float radius: hint_range(0.0, 1.0) = 0.1;
uniform float effectControl: hint_range(0.0, 1.0) = 0.55;
uniform float burnSpeed: hint_range(0.0, 1.0) = 0.33;
uniform float shape: hint_range(0.0, 1.0) = 0.3;

uniform vec3 fireColorTop  : source_color = vec3(1.0, 0.1, 0.0);
uniform vec3 fireColorBottom  : source_color = vec3(1.0, 0.6, 0.4);

void fragment() {
    vec2 centerDistVec = vec2(0.5) - UV;
    
    float distToCircleEdge = length(centerDistVec);
    float distToSquareEdge = max(abs(centerDistVec.x), abs(centerDistVec.y));
    float distToEdge = mix(distToCircleEdge, distToSquareEdge, shape);

    float gradient = smoothstep(0.5, 0.5 - radius, distToEdge);

    vec2 direction = vec2(0, 1) * burnSpeed;
    float noiseValue = texture(textureNoise, UV + direction * TIME).r;

    float opacity = step(radius, mix(gradient, noiseValue, effectControl) - distToEdge);

    // --- ДОБАВЛЕННЫЙ ГРАДИЕНТ ПЛАМЕНИ ---
    float fireGradient = 1.0 - UV.y; // снизу 1, сверху 0
    fireGradient = smoothstep(0.0, 1.0, fireGradient);


    vec3 fireColor = mix(fireColorTop, fireColorBottom, fireGradient);

    vec4 tex = texture(TEXTURE, UV);

    COLOR = tex * vec4(fireColor, opacity);
}