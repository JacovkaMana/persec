shader_type canvas_item;
#define S(a, b, t) smoothstep(a, b, t)
#define NUM_LAYERS 4.
uniform vec4 shader_color : source_color = vec4(0.5, 1.0, 0.96, 1.0);
uniform float time_scale: hint_range(-1.0, 1.0) = 0.0;
//#define SIMPLE


float N21(vec2 p) {
	vec3 a = fract(vec3(p.xyx) * vec3(213.897, 653.453, 253.098));
    a += dot(a, a.yzx + 79.76);
    return fract((a.x + a.y) * a.z);
}

float rgb2v(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	//float d = q.x - min(q.w, q.y);
   // float e = 1.0e-10;
	
	return q.x;
}
	
	
vec2 GetPos(vec2 id, vec2 offs, float t) {
    float n = N21(id+offs);
    float n1 = fract(n*10.);
    float n2 = fract(n*100.);
    float a = t+n;
    return offs + vec2(sin(a*n1), cos(a*n2))*.4;
}

float GetT(vec2 ro, vec2 rd, vec2 p) {
	return dot(p-ro, rd); 
}

float LineDist(vec3 a, vec3 b, vec3 p) {
	return length(cross(b-a, p-a))/length(p-a);
}

float df_line( in vec2 a, in vec2 b, in vec2 p)
{
    vec2 pa = p - a, ba = b - a;
	float h = clamp(dot(pa,ba) / dot(ba,ba), 0., 1.);	
	return length(pa - ba * h);
}

float line(vec2 a, vec2 b, vec2 uv) {
    float r1 = .04;
    float r2 = .01;
    
    float d = df_line(a, b, uv);
    float d2 = length(a-b);
    float fade = S(1.5, .5, d2);
    
    fade += S(.05, .02, abs(d2-.75));
    return S(r1, r2, d)*fade;
}

float NetLayer(vec2 st, float n, float t) {
    vec2 id = floor(st)+n;

    st = fract(st)-.5;
   
    vec2 p[9];
    int i=0;
    for(float y=-1.; y<=1.; y++) {
    	for(float x=-1.; x<=1.; x++) {
            p[i++] = GetPos(id, vec2(x,y), t);
    	}
    }
    
    float m = 0.;
    float sparkle = 0.;
    
    for(int i=0; i<9; i++) {
        m += line(p[4], p[i], st);

        float d = length(st-p[i]);

        float s = (.005/(d*d));
        s *= S(1., .7, d);
        float pulse = sin((fract(p[i].x)+fract(p[i].y)+t)*5.)*.4+.6;
        pulse = pow(pulse, 20.);

        s *= pulse;
        sparkle += s;
    }
    
    m += line(p[1], p[3], st);
	m += line(p[1], p[5], st);
    m += line(p[7], p[5], st);
    m += line(p[7], p[3], st);
    
    float sPhase = (sin(t+n)+sin(t*.1))*.25+.5;
    sPhase += pow(sin(t*.1)*.5+.5, 50.)*5.;
    m += sparkle*sPhase;//(*.5+.5);
    
    return m;
}

//void mainImage( out vec4 fragColor, in vec2 fragCoord )
void fragment()
{
	vec2 fragCoord = FRAGCOORD.xy;
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 uv = (fragCoord-iResolution.xy*.5)/iResolution.y;
	vec2 iMouse = vec2(0., 0.);
	vec2 M = iMouse.xy/iResolution.xy-.5;
    
    float t = TIME*.05;
    //t *= time_scale;
	
    float s = sin(t);
	s = sin(PI);
    float c = cos(t);
	c = cos(PI);
    mat2 rot = mat2( vec2(c, -s), vec2(s, c));
    vec2 st = uv*rot;  
	M *= rot*2.;
    
    float m = 0.;
    for(float i=0.; i<1.; i+=1./NUM_LAYERS) {
        float z = fract(i) + fract(t / 10.);
        float size = mix(15., 1., z * time_scale);
        float fade = S(0., .6, z)*S(1., .8, z);
        
        m += fade * NetLayer(st*size-M*z, i, t);
    }
    
	//float fft  = texelFetch( iChannel0, ivec2(.7,0), 0 ).x;
    //float glow = -uv.y*fft*2.;
	
	float glow = -uv.y * sin(t);
    
    vec3 baseCol = vec3(s, cos(t*.4), -sin(t*.24))*.4+.6;
	baseCol = shader_color.xyz;
    vec3 col = baseCol*m;
	float alph = rgb2v(col) * 0.3;
    col += baseCol*glow;
    
    #ifdef SIMPLE
    uv *= 10.;
    col = vec3(1)*NetLayer(uv, 0., iTime);
    uv = fract(uv);
    //if(uv.x>.98 || uv.y>.98) col += 1.;
    #else
    col *= 1.-dot(uv,uv);
    float t_2 = mod(TIME, 230.) + 20.;
    col *= S(0., 20., t_2)*S(224., 200., t_2);
    #endif
    float dist_to_center = pow(uv.x, 2) + pow(uv.y, 2);
	alph *= pow(dist_to_center, 1.0);
	alph *= 5.;
    COLOR = vec4(col, alph);
}