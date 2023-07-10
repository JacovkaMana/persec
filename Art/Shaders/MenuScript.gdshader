shader_type canvas_item;

uniform float progress : hint_range(0, 100);

// Size of each diamond, in pixels.
uniform float diamondPixelSize = 10.0;

uniform vec2 SCALE = vec2(1000, 1000);
uniform vec4 inner : source_color = vec4(0.125, 0.125, 0.125, 1);
uniform vec4 border : source_color = vec4(0.125, 0.125, 0.125, 1);
uniform vec4 outer : source_color = vec4(0.125, 0.125, 0.125, 1);
uniform float alpha : hint_range(0.0, 255.0) = 255.0;

float HexDist(vec2 p) {
	p = abs(p);
    
    float c = dot(p, normalize(vec2(1,1.73)));
    c = max(c, p.x);
    
    return c;
}



vec4 HexCoords(vec2 uv) {
	vec2 r = vec2(1, 1.73);
    vec2 h = r*.5;
    
    vec2 a = mod(uv, r)-h;
    vec2 b = mod(uv-h, r)-h;
    
    vec2 gv = dot(a, a) < dot(b,b) ? a : b;
    
    float x = atan(gv.x, gv.y);
    float y = 0.5-HexDist(gv);
    vec2 id = uv-gv;
    return vec4(x, y, id.x,id.y);
}

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

float stripes(vec2 p, float s) {
	p *= s;
	float n = fract(p.x - p.y * 1.73);
	if (n > 0.75 || n < 0.25)
		return 0.5;
	return 0.25;
}

void fragment() {
	vec2 uv = UV * SCALE;
    uv *= 10.0;
    vec4 hc = HexCoords(uv / 400.0);
    
	int i = hc.y < 0.05 ? 0 : (hc.y > 0.15 ? 1 : 2);
	vec3 xcol1 = vec3(stripes(uv.xy, 0.005)) * noise(hc.zw / 3.0 + TIME / 5.0);
	vec3 xcol2 = vec3(0.375) * noise(hc.zw / 3.0 + TIME * -0.1);
	vec4 ycol1 = vec4(xcol1, 1.0) * inner / 1.0;
	vec4 ycol2 = vec4(xcol2, 1.0) * border / 1.0;
    vec4 col = i == 0 ? outer : (i == 1 ? ycol1 : ycol2);
	col.a = (alpha / 255.0);

	float xFraction = fract(FRAGCOORD.x / diamondPixelSize);
	float yFraction = fract(FRAGCOORD.y / diamondPixelSize);
	float xDistance = abs(xFraction - 0.5);
	float yDistance = abs(yFraction - 0.5);
	if (hc.z + hc.w + UV.x + UV.y > progress * 0.4) {
		discard;
	}

    COLOR = col;
}