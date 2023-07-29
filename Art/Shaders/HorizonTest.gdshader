/* Based on Cyber Fuji 2020 I basically tore out the grid and simplified it 
for experimentation and manipulation. This version is not nearly as refined as the 
talented kaiware007 version, it is good to contrast and figure out the subtle
details that makes kaiware such a good take.

Swap // to see different effects of things anywhere you see.
//
-> active code
|
->//inactive code


*/
shader_type canvas_item;

uniform vec4 starting_color : source_color = vec4(.0,.1,.2, 1.);
uniform vec4 edge_color : source_color = vec4(1.,0.5, 1., 1.);
uniform float progress : hint_range(0, 100);
uniform float angle : hint_range(0, 1.) = 0.5;
uniform float elevate : hint_range(0, 1.) = 0.35;
uniform float show : hint_range(0, 1.) = 0.4;
uniform int bg_scale: hint_range(1, 10) = 3;
uniform bool pause = false;

uniform sampler2D iChannel0: filter_nearest, repeat_enable;
uniform sampler2D iChannel1: filter_nearest, repeat_enable;

vec2 curve(vec2 uv)
{
	uv = (uv - 0.5) * 2.0;
	uv *= 1.1;	
	uv.x *= 1.0 + pow((abs(uv.y) / 5.0), 2.0);
	uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
	uv  = (uv / 2.0) + 0.5;
	uv =  uv *0.92 + 0.04;
	return uv;
}

float grid(vec2 uv){

// size.y effects brightness in smoothstep below
    //vec2 size = vec2(uv.y, uv.y * uv.y) * 0.005;
	//vec2 size = vec2(uv.y, uv.y * uv.y * .4) * .01);

	//vec2 size = vec2(uv.y, uv.y * uv.y * .4) * (sin(TIME) / 100. + .01);
	
	vec2 size = vec2(uv.y, uv.y * uv.y * .3) * (.005);

    // speed of grid movement, alter float number
    //uv.y += TIME * 3.;
    
// Angle change also effects color/glow slightly    
//    uv = abs(fract(uv));
    uv = abs(fract(uv) - angle);

    // size variable can be manipulated for interesting results
    vec2 lines = smoothstep(size * 1.0, vec2(0.), uv);
    lines += smoothstep(size * 1.0, vec2(0.), uv) * 5.0;

// Horizon blured by 'clamp',
	//return clamp(lines.x + lines.y, 0.0, 1.0);
    return lines.x + lines.y;
//    return clamp(lines.x + lines.y, 0.0, 1.0);
    }



void fragment()
{
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 fragCoord = vec2(FRAGCOORD.x, iResolution.y - FRAGCOORD.y);
	
	vec2 uv = fragCoord.xy / iResolution ;
	
    uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

	
	
	//uv = fragCoord.xy / iResolution ;
    //lazy shift, will update later with better implementation
    uv -= elevate;
	//uv.x += cos(TIME);
    
    //starting color
	vec2 scale = iResolution.xy / vec2(32., 32.);
	vec2 uv0 = FRAGCOORD.xy / vec2(32., 32.);
	uv0 /= float(bg_scale);
	//uv0.x += TIME;
	vec4 sampling0 = texture(iChannel0, uv0);
	
	vec2 uv1 = FRAGCOORD.xy / vec2(32., 32.);
	//uv1 /= float(bg_scale);
	//uv1.x += TIME;
	vec4 sampling1 = texture(iChannel1, uv1);
	

	
    vec3 col = sampling0.rgb;
    
    //ugly if statement, will change later
    if (uv.y < - show)
    {
//Messy, just experiment
		col = starting_color.rgb;
		uv.x += 0.26;	
        uv.y = 4.0 / (abs(uv.y + 0.2 * uv.y + 0.2) + .05) - 0.0;
		
		//uv.y *= 1.0 - pow((abs(uv.x) / 4.0), 2.0);  //curve
        
		//uv.y = 2.5 / (abs(uv.y + .2) + .1);
        
        //Pattern multiplication, see Book of Shaders, patterns chapter
        uv.x *= uv.y * 0.5;
		

        //Line creation. 
		//uv.x -= fract(TIME * 0.2);  
		uv.y += fract(TIME * 0.5); 
		if (pause) {
			uv.y -= fract(TIME * 0.5); 
		}
		//uv.y += TIME;   
        float gridVal = grid(uv);
		//uv.y += TIME;
		col = texture(iChannel1, uv).rgb;
		
        col = mix(col, edge_color.rgb, gridVal);
		//col = mix(col, sampling.rgb, 0.5);
    } 
     

    COLOR = vec4(col, 1.0);
}