shader_type canvas_item;

uniform float power : hint_range(1., 100., 1.) = 5.;

const int NB_BARS = 8;
const int NB_SAMPLES = 16;
// WARNING : NB_BARS x NB_SAMPLES must be 512

// space between bars (relative to bar width)
const float SPACE = 0.15;

// space without bars, left and right (relative to window size)
const float SIDE_SPACE = 0.04;

// from here: www.shadertoy.com/view/XtjBzG
vec3 heatColorMap(float t)
{
    //t *= 4.;
	
	vec3 start = vec3(64. / 255., 70. / 255., 105. / 255.);
	vec3 end = vec3(15. / 255., 18. / 255., 36. / 255.);
	
	return vec3(start.r + (end.r - start.r) * t, 
	start.g + (end.g - start.g) * t, 
	start.b + (end.b - start.b) * t);
    return clamp(vec3(min(t-1.5, 4.5-t), 
                      min(t-0.5, 3.5-t), 
                      min(t+0.5, 2.5-t)), 
                 0., 1.);
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    vec2 iResolution = 1.0 / TEXTURE_PIXEL_SIZE;
    //vec2 uv = FRAGCOORD.xy /iResolution.xy;
	vec2 uv = UV;
	//vec2 uv = UV;
	uv.y = 1.0 - uv.y;
    
    uv.x = (uv.x-SIDE_SPACE)/(1.-2.*SIDE_SPACE);
    
    if(uv.x<0. || uv.x > 1.)
    {
    	COLOR.a = 0.;
    }
    
    float NB_BARS_F = float(NB_BARS);
    int bar = int(floor(uv.x * NB_BARS_F));
    
    float f = 0.;
    f = 0.;
    
		
	
//    for(int t=0; t<NB_SAMPLES; t++)
//    {
//    	//f += texelFetch(iChannel0, ivec2(bar*NB_SAMPLES+t, 0), 0).r;
//		//f += (( abs(cos(5.0 * TIME + float(bar) / 15.0 ) - sin(TIME)) +  float(NB_SAMPLES - bar + 1) * 0.05) / 5.0) * (cos(float(bar) / 10.0) + 1.0) * power / 100.0 ;
//    	f += fract(rand( vec2( cos(TIME * float(bar)) , 1.0))) / 1.4 * power / 100.0 ;
//	}
	f = 
	sin(
	cos( clamp(power / 10., 2., 100.) * TIME + float(bar) / 2.0 )
	- sin(TIME * clamp(power / 20., 2., 100.) ) 
	+ cos(TIME * clamp(power / 30., 2., 100.)) 
	+ cos(float(bar)) 
	+ sin(float(bar) / 2.0)
	);
	//f += float(NB_SAMPLES - bar + 1) * 0.4;
	//f += power / 10000.0;
	f *= clamp(power / 100.0 * 1.0, 0., power / 100.0 * 1.0);
	//f = clamp(f, 0.05, 0.9);
	//f = sin(rand( vec2( fract(TIME / 3000.0) , float(bar)))) * 10.0 * power / 100.0 ;
	
//    f /= float(NB_SAMPLES);
    
//    f *= 0.85;
//    f += 0.02;
    
    vec3 c = heatColorMap(f);
    
    
    float bar_f = float(bar)/NB_BARS_F;
    
    //c *= 1.-step(f, uv.y);
    //c *= 1.-step(1.-SPACE*.5, (uv.x-bar_f)*NB_BARS);
    //c *= 1.-step(1.-SPACE*.5, 1.-(uv.x-bar_f)*NB_BARS);
    
    c *= mix(1.,0., clamp((uv.y-f)*iResolution.y,0.,1.));
    c *= clamp((min((uv.x-bar_f)*NB_BARS_F, 1.-(uv.x-bar_f)*NB_BARS_F)-SPACE*.5)/NB_BARS_F*iResolution.x, 0., 1.);
    
	if (c.rgb == vec3(0.,0.,0.)) {
		COLOR.a = 0.;
		COLOR.rgb = vec3(0.5, 0.2, 0.2);
	}
	else {
		COLOR.a = 1.0 - uv.y;
		COLOR.rgb = c;
	}
}