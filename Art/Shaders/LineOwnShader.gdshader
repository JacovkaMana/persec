// "Rainbow Snake" by Martijn Steinrucken aka BigWings - 2015
// Email:countfrolic@gmail.com Twitter:@The_ArtOfCode
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

shader_type canvas_item;
uniform float size = 10.;
#define MOD3 vec3(.1031,.11369,.13787)

float hash12(vec2 p) {
     // From https://www.shadertoy.com/view/4djSRW
	// Dave Hoskins
	vec3 p3  = fract(vec3(p.xyx) * MOD3);
    p3 += dot(p3, p3.yzx + 19.19);
    return fract((p3.x + p3.y) * p3.z);
}

float brightness(vec2 uv, vec2 id) {
    // returns the brightness of a scale, based on its id
	float t = TIME;
    float n = hash12(id);
    float c = mix(0.7, 1., n);				// random variation
    
    float x = abs(id.x - size * .5);
    float stripes = sin(x*.65+sin(id.y*.5)+.3)*.5+.5;		// pattern
    stripes = pow(stripes, 4.);
    c *= 1.-stripes*.5;
    
    float y = floor(uv.y * size);
    float twinkle = sin(t+n*6.28)*.5 +.5;
    twinkle = pow(twinkle, 40.);
    c += twinkle*.5;                 
    
    return c;
}

float spokes(vec2 uv, float spikeFrequency) {
	// creates spokes radiating from the top of the scale
    
    vec2 p = vec2(0., 1.);
    vec2 d = p-uv;
    float l = length(d);
    d /= l;
    
    vec2 up = vec2(1., 0.);
    
    float c = dot(up, d);
    c = abs(sin(c*spikeFrequency));
    c *= l;
    
    return c;
}

vec4 ScaleInfo(vec2 uv, vec2 p, vec3 shape) {
    
    float spikeAmount = shape.x;
    float spikeFrequency = shape.y;
    float sag = shape.z;
    
    uv -= p;
    
    uv = uv*2.-1.;
  	
    float d2 = spokes(uv, spikeFrequency);
    
    uv.x *= 1.+uv.y*sag;
   
	float d1 = dot(uv, uv);					// distance to the center of the scale
   
    float threshold = 1.;//sin(iTime)*.5 +.5;
    
    float d = d1+d2*spikeAmount;
    
    float f = 0.05;//fwidth(d);
    float c = smoothstep(threshold, threshold-f, d);
    
    return vec4(d1, d2, d, c);
}

vec4 ScaleCol(vec2 uv, vec2 p, vec4 i) {
    
    vec3 col1 = vec3(.1, .3, .2);
    vec3 col2 = vec3(.8, .5, .2);
    vec3 baseCol = vec3(.1, .3, .2)*3.;
    uv-=p;
    
    float grad = 1.-uv.y;
    float col = grad+i.x;
    col = col*.2+.5;
    
    vec4 c = vec4(col*baseCol, i.a);
    
    c.rgb = mix(c.rgb, col1, i.y*i.x*.5);		// add spokes
    c.rgb = mix(c.rgb, col2, i.x);				// add edge highlights
            
    c = mix(vec4(0.), c, i.a);
    
    float fade = 0.3;
    float shadow = smoothstep(1.+fade, 1., i.z);
  
	c.a = mix(shadow*.25, 1., i.a);
    
    return c;
}


vec4 Scale(vec2 uv, vec2 p, vec3 shape) {
    
    vec4 info = ScaleInfo(uv, p, shape);
    vec4 c = ScaleCol(uv, p, info);
    
    return c;
}

vec4 ScaleTex(vec2 uv, vec2 uv2, vec3 shape) {
    // id = a vec2 that is unique per scale, can be used to apply effects on a per-scale basis
    // shape = a vec3 describing the shape of the scale:
    //			x = the amount of spikyness, can go negative to bulge spikes the opposite way
    //			y = the number of spikes
    //          z = the taper of the scale (0=round -1=top wider 1=bottom wider)
    
    vec2 id = floor(uv2);
    uv2 -= id;
    
    // need to render a bunch of scales per pixel, so they can overlap
    vec4 rScale = Scale(uv2, vec2(.5, 0.01), shape);
   	vec4 lScale = Scale(uv2, vec2(-.5, 0.01), shape);
    vec4 bScale = Scale(uv2, vec2(0., -0.5), shape);
    vec4 tScale = Scale(uv2, vec2(0., 0.5), shape);
    vec4 t2Scale = Scale(uv2, vec2(1., 0.5), shape);
    
    // every scale has a slightly different brightness + pattern
    rScale.rgb *= brightness(uv, id+vec2(1.,0.));
    lScale.rgb *= brightness(uv, id+vec2(0.,0.));
    
    bScale.rgb *= brightness(uv, id+vec2(0.,0.));
    
    tScale.rgb *= brightness(uv, id+vec2(0.,1.));
    t2Scale.rgb *= brightness(uv, id+vec2(2.,1.));
    
    // start with base color and alpha blend in all of the scales
    vec4 c =  vec4(.1, .3, .2,1.);
    c = mix(c, bScale, bScale.a);
    c = mix(c, rScale, rScale.a);
    c = mix(c, lScale, lScale.a);
    c = mix(c, tScale, tScale.a);
    c = mix(c, t2Scale, t2Scale.a);
    
   // c.rg = uv;
   // c.b = 0.;
    return c;
}

void fragment()
{
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 fragCoord = FRAGCOORD.xy;
	
    float aspect = iResolution.x/iResolution.y;
    
	vec2 uv = fragCoord.xy / iResolution.xy;  // get uvs in 0 to 1 range
    //vec2 m = iMouse.xy/iResolution.xy;
    vec2 m = vec2(0.);
	m = m*2. - 1.;
    float t = TIME;
    
    
    
   	uv.x += sin(t+uv.y)*.1;
    
    uv.x*=2.;
    
    uv -=.5;
    
    
    vec2 uv2 = uv * size;						// uv2 -2.5 - 2.5
    uv2.y -= t;
    uv +=.5;
       
    float grad = (uv2.y+12.5)/15.;				// goes from 0-1 

    vec3 center = vec3(.6, 1., -.8);  			// scale shape settings for center -> amount frequency sag
    vec3 outside = vec3(0.1, 8., -.9);  		// settings for side
    
    float sideFade = pow(uv.x-1.,2.);
    vec3 shape = mix(center, outside, sideFade);// morph between scale shapes
    
   // shape = mix(center, outside, 1.);
    
  
    
    vec4 c = ScaleTex(uv, uv2, shape);			// sample scales
    c = mix(c, vec4(c.g), sideFade);			// fade color towards the edges
    
    t*=.1;										// rainbow....
    c.r += sin(t)*.4;
    c.g -= abs(sin(t*1.324))*.435;
    c.b += sin(t*0.324)*.3;
    
    //float y = pow(uv.y-.5,2.)*4.;				// vignette
    //c *= 1.-y;
	
    COLOR = texture(TEXTURE, uv);
	COLOR.a = c.g;
	
}

