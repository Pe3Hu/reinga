shader_type canvas_item;

/* -------------------- utils -------------------- */

vec2 sincos(float x){
    return vec2(sin(x), cos(x));
}

float vec_fastmix(float a, float b, float t){
    return a + (b - a) * t;
}

float vec_smootherstep(float e0, float e1, float x){
    float t = clamp((x - e0) / (e1 - e0), 0.0, 1.0);
    return t*t*t*(t*(t*6.0 - 15.0) + 10.0);
}

/* -------------------- noise -------------------- */

vec3 noise_vec2_xyx(vec2 v){ return vec3(v.x, v.y, v.x); }
vec3 noise_vec3_yzx(vec3 v){ return vec3(v.y, v.z, v.x); }

float noise_hash1_2(vec2 v){
    vec3 v3 = noise_vec2_xyx(v);
    v3 = fract(v3 * 0.1031);
    v3 += dot(v3, noise_vec3_yzx(v3) + 33.33);
    return fract((v3.x + v3.y) * v3.z);
}

float noise_value(vec2 p){
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0 - 2.0*f);

    float a = noise_hash1_2(i);
    float b = noise_hash1_2(i + vec2(1.0,0.0));
    float c = noise_hash1_2(i + vec2(0.0,1.0));
    float d = noise_hash1_2(i + vec2(1.0,1.0));

    return mix(mix(a,b,u.x), mix(c,d,u.x), u.y);
}

/* -------------------- FBM -------------------- */

float fbm(vec2 p){
    float t = 0.0;
    float a = 1.0;

    for(int i=0;i<4;i++){
        t += a * noise_value(p);
        p *= 2.0;
        a *= 0.5;
    }

    return t;
}

/* -------------------- MAP -------------------- */

float map(vec3 p){
    float h = fbm(p.xz) * 0.5;
    return (p.y + h * 0.75) * 0.5;
}

/* -------------------- RAYMARCH -------------------- */

float ray_march(vec3 ro, vec3 rd){
    float t = 0.0;

    for(int i=0;i<128;i++){
        vec3 p = ro + rd * t;
        float d = map(p);

        if(d < 0.003 * t || t > 25.0) break;
        t += d;
    }

    return t;
}

/* -------------------- CAMERA -------------------- */

vec3 camera(vec3 ro, vec3 ta, float fov, vec2 uv){
    vec3 w = normalize(ta - ro);
    vec3 u = normalize(cross(w, vec3(0.0,1.0,0.0)));
    vec3 v = cross(u, w);

    float f = 1.0 / tan(fov * 0.5);

    return normalize(u * uv.x + v * uv.y + w * f);
}

/* -------------------- ACES -------------------- */

vec3 aces(vec3 x){
    return clamp((x*(2.51*x + 0.03)) /
                (x*(2.43*x + 0.59) + 0.14), 0.0, 1.0);
}

/* -------------------- NOISE -------------------- */

float white_noise(vec2 p){
    return noise_hash1_2(p);
}

/* -------------------- MAIN -------------------- */

void fragment(){

    vec2 res = 1.0 / SCREEN_PIXEL_SIZE;

    vec2 uv = FRAGCOORD.xy / res;
    vec2 coord = uv * 2.0 - 1.0;
    coord.x *= res.x / res.y;
    coord.y = -coord.y;

    float ttime = TIME * 0.3;

    vec2 sc = sincos(ttime * 0.5);

    vec3 ro = vec3(-sc.x * 0.5, 0.0, ttime - 2.0);
    vec3 ta = vec3(sc.x * 0.5, 0.0, ttime);

    vec3 rd = camera(ro, ta, 1.0, coord);

    vec3 sun_dir = normalize(vec3(0.3, 0.07, 1.0));

    /* -------------------- SKY (MORBIER / DARK TONE) -------------------- */

    float h = rd.y;

    vec3 hor_col = vec3(0.55, 0.03, 0.02);
    vec3 bot_col = vec3(0.45, 0.10, 0.08);
    vec3 sun_col = vec3(0.75, 0.65, 0.60);

    vec3 back_col = mix(hor_col, hor_col * 0.3, vec_smootherstep(0.0, 0.25, h));
    back_col = mix(back_col, bot_col, max((0.1 - h), 0.0));

    float sun = max(dot(rd, sun_dir), 0.0);

    back_col += sun_col * pow(sun, 1800.0);
    back_col += sun_col * 0.18 * pow(sun, 90.0);
    back_col += vec3(0.18,0.12,0.08) * pow(sun, 5.0);

    /* -------------------- TERRAIN -------------------- */

    float t = ray_march(ro, rd);
    vec3 col;

    if(t < 25.0){
        float decay = 1.0 - exp(-0.12 * t);
        col = mix(vec3(0.01,0.0,0.0), back_col, decay);
    } else {
        col = back_col;

        float clouds_altitude = 6.0;
        float clouds_dist = (clouds_altitude - ro.y) / rd.y;

        if(clouds_dist > 0.0){
            vec2 cpos = ro.xz + rd.xz * clouds_dist;

            float n = fbm(cpos * 0.5);
            float clouds = max(n - 0.3, 0.0);

            float fade = vec_smootherstep(0.0, 0.3, rd.y);

            col = mix(col, col * 2.0, clouds * fade);
        }
    }

    /* -------------------- TONEMAP -------------------- */

    col = aces(col);

    col = (1.10 * sqrt(col)) - (0.18 * col); // darker gamma

    col *= vec3(0.90, 0.85, 0.82); // global dark tint

    /* -------------------- VIGNETTE -------------------- */

    float vign = (16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y));
    col *= mix(0.20, 1.0, pow(vign, 0.35));

    /* -------------------- DITHER -------------------- */

    col += white_noise(FRAGCOORD.xy) * 0.01;

    COLOR = vec4(clamp(col, 0.0, 1.0), 1.0);
}