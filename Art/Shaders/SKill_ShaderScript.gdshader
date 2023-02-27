shader_type canvas_item;

uniform sampler2D noise_img: filter_nearest,repeat_enable;
uniform sampler2D gradient_tex;
uniform float speed = 1.0;
uniform vec4 main_color: source_color = vec4(1.0);
uniform vec4 alpha_color: source_color = vec4(1.0);

void fragment() {
	
	vec2 uv1 = vec2(UV.x - TIME * speed * 0.1, UV.y);
	vec2 uv2 = vec2(UV.x + TIME * speed * 0.1, UV.y);
	vec2 uv3 = vec2(UV.x, UV.y + TIME * speed * 0.1);
	
	
	float gradient = texture( gradient_tex, UV).r;
	float noise_r = texture( noise_img, uv1).r;
	float noise_g = texture( noise_img, uv2).g;
	float noise_b = texture( noise_img, uv3).b;
	
	
	vec3 new_color = vec3(noise_r, noise_g, noise_b);
	
	float new_alpha = noise_r * noise_b * noise_g;
	//COLOR.rgb = new_color;
	COLOR.rbg = main_color.rbg;
	//COLOR.a = texture( TEXTURE, UV).a;
	COLOR.a = clamp(new_alpha * 15.0 * texture( TEXTURE, UV).a, 0.0, 1.0);
}
