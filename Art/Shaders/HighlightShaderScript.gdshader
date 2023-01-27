/* 
Rainbow outline by @Farfalk and @ThePadDev, And Edit for @LURGX in 2022

Apply to canvas items with transparent backgrounds.
Check that there is sufficient transparent background space for the outline!

CC0 License (but citation is welcome <3)
All code is property of @Farfalk and @ThePadDev
Thanks for shader and I'm a newbie with shaders 
*/

shader_type canvas_item;

uniform bool rainbow  = false; //Activate the rainbow or select you color
uniform vec4 line_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);//color line
uniform float line_scale : hint_range(0, 20) = 1.2;    // thickness of the line
uniform float frequency : hint_range(0.0, 2.0) = 0.5;  // frequency of the rainbow
uniform float light_offset : hint_range(0.00001, 1.0) = 0.5;   // this offsets all color channels;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * line_scale;
	
	float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
	outline = min(outline, 1.0);
	

	vec4 color = texture(TEXTURE, UV);
	float angle = 0.8 + abs(sin(TIME * 1.5*PI));
	COLOR = mix(color, line_color * angle , outline - color.a);


}