shader_type canvas_item;
#define S(a,b,t) smoothstep(a,b,t)

uniform vec4 color : source_color = vec4( 0.039 , 0.078, 0.352, 1.0);


// Generate noise with fractional content of sine wave
// See https://thebookofshaders.com/10/
// Created by inigo quilez - iq/2014
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
vec2 hash( vec2 p )
{
    p = vec2( dot(p,vec2(2127.1,81.17)), dot(p,vec2(1269.5,283.37)) );
	return fract(sin(p)*43758.5453);
}

float noise( in vec2 p )
{
    vec2 i = floor( p );
    vec2 f = fract( p );	
	vec2 u = f*f*(3.0-2.0*f);
    float n = mix( mix( dot( -1.0+2.0*hash( i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ), 
                        dot( -1.0+2.0*hash( i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                   mix( dot( -1.0+2.0*hash( i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ), 
                        dot( -1.0+2.0*hash( i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
	return 0.5 + 0.5*n;
}

mat2 Rot(float a)
{
    float s = sin(a);
    float c = cos(a);
	return mat2( vec2(c, -s), vec2(s, c));
    //return mat2(c, -s, s, c);
}

void fragment()
{
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 uv = FRAGCOORD.xy /iResolution.xy;
    vec2 tuv = uv;
    tuv -= .5;

    // Rotate with Noise
    float degree = noise(vec2(TIME*.1, tuv.x*tuv.y));
    float ratio = iResolution.x / iResolution.y;
    tuv.y *= 1./ratio;
    tuv *= Rot(radians((degree-.5)*720.+180.));
	tuv.y *= ratio;
    
    // Wave warp with sin
    float frequency = 5.;
    float amplitude = 30.;
    float speed = TIME * 2.;
    tuv.x += sin(tuv.y*frequency+speed)/amplitude;
   	tuv.y += sin(tuv.x*frequency*1.5+speed)/(amplitude*.5);

    vec3 color1 = color.rgb; //  	10  20  90
    vec3 color2 = 1.8 * color.rgb; //    57  78  239
    vec3 color3 = 3.0 * color.rgb; //    72  211 205
    vec3 color4 =  1.0 * color.rgb; //    38  58  196
    
    vec3 layer1 = mix(color1, color2, S(-.3, .2, (tuv*Rot(radians(-5.))).x));
    vec3 layer2 = mix(color3, color4, S(-.3, .2, (tuv*Rot(radians(-5.))).x));   
    vec3 mixed = mix(layer1, layer2, S(.5, -.3, tuv.y));
    COLOR = vec4(mixed,1.0);
}