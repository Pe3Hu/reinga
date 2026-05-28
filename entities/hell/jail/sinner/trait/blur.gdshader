shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float blur_amount : hint_range(0.0, 5.0) = 0.8;
uniform float radius : hint_range(0.0, 1.0) = 0.25;
uniform float softness : hint_range(0.0, 0.5) = 0.5;

void fragment() {
    vec2 uv = SCREEN_UV;

    float dist = distance(UV, vec2(0.5));

    float mask = 1.0 - smoothstep(radius, radius + softness, dist);

    vec3 sharp = texture(SCREEN_TEXTURE, uv).rgb;
    vec3 blurred = textureLod(SCREEN_TEXTURE, uv, blur_amount).rgb;

    COLOR.rgb = mix(sharp, blurred, mask);
}