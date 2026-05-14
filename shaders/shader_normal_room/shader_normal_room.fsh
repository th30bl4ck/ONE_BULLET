varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vWorldPos;

uniform float u_time;
uniform vec2 u_view_pos;
uniform vec2 u_view_size;
uniform vec2 u_screen_size;
uniform vec2 u_room_size;

float hash21(vec2 p)
{
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float noise2(vec2 p)
{
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);

    float a = hash21(i);
    float b = hash21(i + vec2(1.0, 0.0));
    float c = hash21(i + vec2(0.0, 1.0));
    float d = hash21(i + vec2(1.0, 1.0));

    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float beam(vec2 uv, float top_x, float slope, float width, float fade_top, float fade_bottom)
{
    float center = top_x + slope * uv.y;
    float edge = smoothstep(width, 0.0, abs(uv.x - center));
    float vertical = smoothstep(fade_top, fade_top + 0.16, uv.y) * smoothstep(fade_bottom, fade_bottom - 0.22, uv.y);
    return edge * vertical;
}

float dust_mote(vec2 uv, float scale, vec2 drift)
{
    vec2 grid = uv * scale + drift;
    vec2 cell = floor(grid);
    vec2 local = fract(grid);
    vec2 mote_pos = vec2(hash21(cell + 2.7), hash21(cell + 9.1));
    float seed = hash21(cell + 15.4);
    float mote = smoothstep(0.998, 1.0, seed);
    mote *= smoothstep(0.055, 0.0, length(local - mote_pos));
    mote *= 0.55 + 0.45 * sin(u_time * 2.4 + seed * 6.2831);
    return mote;
}

void main()
{
    vec2 screen_uv = v_vWorldPos / max(u_screen_size, vec2(1.0));
    vec2 world_pos = u_view_pos + screen_uv * u_view_size;
    vec2 uv = world_pos / max(u_room_size, vec2(1.0));
    vec2 centered = screen_uv - vec2(0.5);
    float aspect = u_screen_size.x / max(u_screen_size.y, 1.0);

    float slow = sin(u_time * 0.18) * 0.006;
    float wide_beam = beam(uv, 0.27 + slow, 0.30, 0.235, -0.08, 1.15);
    float main_beam = beam(uv, 0.50 - slow, 0.14, 0.135, -0.05, 0.98);
    float side_beam = beam(uv, 0.76 + slow * 0.5, -0.18, 0.155, 0.04, 1.08);
    float thin_beam = beam(uv, 0.62, 0.30, 0.052, 0.00, 0.92);

    float haze_noise = noise2(uv * vec2(5.0, 3.2) + vec2(u_time * 0.025, -u_time * 0.012));
    haze_noise += noise2(uv * vec2(12.0, 7.0) + vec2(-u_time * 0.018, u_time * 0.010)) * 0.45;
    haze_noise /= 1.45;

    float rays = wide_beam * 0.34 + main_beam * 0.52 + side_beam * 0.28 + thin_beam * 0.20;
    rays *= 0.72 + haze_noise * 0.38;

    float pool_left = smoothstep(0.56, 0.0, length((uv - vec2(0.24, 0.28)) * vec2(aspect * 0.72, 1.0)));
    float pool_mid = smoothstep(0.48, 0.0, length((uv - vec2(0.55, 0.42)) * vec2(aspect * 0.92, 1.0)));
    float pooled_light = (pool_left * 0.18 + pool_mid * 0.12) * (0.55 + haze_noise * 0.45);

    float dust = dust_mote(uv, 72.0, vec2(u_time * 0.015, -u_time * 0.010));
    dust += dust_mote(uv + vec2(11.7, 3.2), 46.0, vec2(-u_time * 0.012, -u_time * 0.006)) * 0.6;

    float edge_vignette = smoothstep(0.30, 0.88, length(centered * vec2(0.90 * aspect, 1.05)));
    float top_shadow = smoothstep(0.18, -0.02, screen_uv.y) * 0.22;
    float shadow = clamp(edge_vignette * 0.56 + top_shadow, 0.0, 0.64);

    float light = clamp(rays * 0.36 + pooled_light + haze_noise * 0.045, 0.0, 0.42);
    float dust_alpha = clamp(dust * (0.35 + rays * 0.9), 0.0, 0.55);

    vec3 shadow_col = vec3(0.018, 0.070, 0.052);
    vec3 warm_col = vec3(1.0, 0.66, 0.25);
    vec3 mote_col = vec3(1.0, 0.88, 0.50);

    float alpha = clamp(shadow + light + dust_alpha, 0.0, 0.70);
    vec3 color = mix(shadow_col, warm_col, smoothstep(0.02, 0.38, light));
    color = mix(color, mote_col, clamp(dust_alpha * 1.8, 0.0, 1.0));

    gl_FragColor = vec4(color, alpha) * v_vColour;
}
