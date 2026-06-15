shader_type canvas_item;

uniform float SCALE = 0.8;
uniform float BRIGHTNESS = 6.0;
uniform vec3 final_color : source_color = vec3(0.2, 0.6, 1.0);

float random(float t)
{
    return (cos(t) + cos(t * 1.3 + 1.3) + cos(t * 1.4 + 1.4)) / 3.0;   
}

vec2 rotateUV(vec2 uv, float angle) 
{
    angle = angle * TAU;
    mat2 matrix = mat2(
        vec2(cos(angle), -sin(angle)),
        vec2(sin(angle), cos(angle))
    );
    return matrix * uv;
}

float arc(float r, vec2 uv, float orientation, float radius, float section)
{
    uv = rotateUV(uv, orientation);
    float theta = atan(uv.x, uv.y) / TAU;

    float t = 100.0 * section;
    float value = 
        min(3.0, pow(0.0008 / abs(r - radius), 2.2)) *
        min(3.0, pow(0.004 / abs(theta / t), t / 1.0));
    
    return value;
}

float radial(float r, vec2 uv, float orientation, float radius, float section)
{
    uv = rotateUV(uv, orientation);
    float theta = atan(uv.x, uv.y) / TAU;

    float t = 100.0 * section;
    float value = 
        min(3.0, 0.0002 / abs(theta)) *
        min(3.0, pow(0.004 / abs((r - radius) / t), t / 2.0));

    return value;
}

void fragment()
{
    vec2 uv = UV;
    uv -= 0.5;
    uv *= SCALE;
    
    float r = length(uv);
    
    float value = 0.0;
    
    // Первые 6 лучей — статичные оси
    for(float i = 0.0; i < 6.0; i += 1.0)
    {
        float orientation = i / 6.0;
        
        // Радиус: плавно меняется со временем
        float radius = 0.2 + random((i * 534.5 + TIME) * 1.0) / 30.0;
        float section = 0.15;
        
        value += arc(r, uv, orientation, radius, section);
        value += radial(r, uv, orientation + 0.25, radius, section);    
    }
    
    // Вторые 14 лучей — случайно рядом с основными направлениями
    for(float i = 6.0; i < 9.0; i += 1.0)
    {
        // Определяем, рядом с каким из 6 направлений располагается луч
        float baseDirection = mod(i - 6.0, 6.0) / 6.0;
        
        // Случайный офсет в пределах ~5-8% от полного оборота
        float randomOffset = random((i * 453.6) * 0.07) * 0.06;
		randomOffset += sign(randomOffset) * 0.04;
        float orientation = baseDirection + randomOffset;
        
        // Радиус: плавно меняется со временем
        float radius = 0.2 + random((i * 534.5 + TIME) * 1.0) / 30.0;
        float section = 0.1;
        
        value += arc(r, uv, orientation, radius, section);
        value += radial(r, uv, orientation + 0.25, radius, section);    
    }
    
   
    float verticalFade = cos(uv.y * 6.28) * 0.5 + 0.5;
    
    float intensity = value * BRIGHTNESS;
    vec4 finalColor = vec4(final_color * intensity * verticalFade, intensity);
    
    COLOR = finalColor;
}
