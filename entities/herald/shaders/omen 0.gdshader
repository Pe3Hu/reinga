shader_type canvas_item;

const vec4 lineColor = vec4(0.25, 0.5, 1.0, 1.0);

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
        min(2.0, pow(0.001 / abs(r - radius), 2.0)) *
        min(2.0, pow(0.005 / abs(theta / t), t / 1.0));
    
    return value;
}

float radial(float r, vec2 uv, float orientation, float radius, float section)
{
    uv = rotateUV(uv, orientation);
    float theta = atan(uv.x, uv.y) / TAU;

    float t = 100.0 * section;
    float value = 
        min(2.0, 0.00025 / abs(theta)) *
        min(2.0, pow(0.005 / abs((r - radius) / t), t / 2.0));

    return value;
}

void fragment()
{
    vec2 uv = UV;
    float aspect = 1.0 / SCREEN_PIXEL_SIZE.x / (1.0 / SCREEN_PIXEL_SIZE.y);
    uv.x = (uv.x - 0.5) * aspect + 0.5;
    uv -= 0.5;
    
    float r = length(uv);
    
    float value = 0.0;
    for(float i = 0.0; i < 32.0; i += 1.0)
    {
        float radius = 0.3 + random((i * 534.5 + TIME) * 1.0) / 40.0;
        float orientation = 0.5 + 0.5 * random((i * 453.6 + TIME) * 0.07);
        float section = 0.1 + random((i * 346.3 + TIME) * 0.1) / 10.0;
 
        value += arc(r, uv, orientation, radius, section);

        orientation = 0.5 + 0.5 * random((i * 823.3 + TIME) * 0.01);
        value += radial(r, uv, orientation, radius, section);    
    }
    
    vec4 bgColor0 = lineColor * 0.5;
    vec4 bgColor1 = lineColor - vec4(0.2, 0.2, 0.7, 1.0);
    
    vec3 color = vec3(0.2, 0.6, 1.0);

    float verticalFade = cos(uv.y * 6.28) * 0.5 + 0.5;
    vec4 finalColor = mix(bgColor0, bgColor1, uv.x / 1.0);
    finalColor *= verticalFade / 2.0;

    finalColor += vec4(color * value, 1.0);
    
    COLOR = finalColor;
}
