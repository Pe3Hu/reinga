shader_type canvas_item;

void fragment() {
    vec2 fragCoord = FRAGCOORD.xy;
    vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    float iTime = TIME;

    vec2 uv = (1.2 * fragCoord - iResolution.xy) / min(iResolution.x, iResolution.y);

    // волны сверху вниз
    uv.y *= -1.0;

    for (float i = 2.15; i < 7.150; i++) {
        uv.y += i * 0.1 / i *
            sin(uv.x * i * i + iTime * 0.5) *
            sin(uv.y * i * i + iTime * 0.5);
    }

    // 🔴 RED / BLOOD PALETTE (вместо зелёного)
    vec3 col;
    col.r = uv.y + 0.55;   // основной красный подъём
    col.g = uv.y - 0.15;   // приглушаем зелёный
    col.b = uv.y - 0.25;   // ещё сильнее режем синий

    COLOR = vec4(col, 1.0);
}