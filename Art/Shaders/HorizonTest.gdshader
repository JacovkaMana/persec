shader_type canvas_item;

uniform vec4 color1 : source_color = vec4(0., 0., 0., 1);
uniform vec4 color2 : source_color = vec4(1., 1., 1., 1);

void fragment()
{
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	float rot = PI * 1.0;
   	mat2 m = mat2( vec2(cos(rot), -sin(rot)), vec2(sin(rot), cos(rot)));
	
    vec2 uv = ( (1.0 * FRAGCOORD.xy) / iResolution.xy) * 2.0 - 1.0;
	uv  = m * uv;
    uv.x *= iResolution.x / iResolution.y;
    
    vec3 camPos = vec3(0.0, 1.0, -3.0);
    vec3 rayDir = normalize(vec3(uv, 1.0));
    
    vec3 bg = mix(vec3(1.0, 0.5, 0.0), vec3(0.1, 0.15, 0.3), uv.y * 0.5 + 0.5);
    
    float time = TIME * 0.5;
    float floorSpeed = 2.0;
    float floorPosZ = mod(floorSpeed * time, 4.0) - 2.0;
    
    float t = ((0.0 - camPos.y + 0.0) / (rayDir.y + 0.0 ));
    vec3 hitPos = camPos + t * rayDir;
    hitPos.z -= floorPosZ;
    vec3 floorColor = mod(floor(hitPos.x * 0.5) + floor(hitPos.z * 0.5), 2.0) < 1.0 ? color2.rgb : color1.rgb;
    

 
    bg = mix(bg, floorColor, smoothstep(0.0, 1.0, t));
	COLOR = vec4(bg, 1.0);
}