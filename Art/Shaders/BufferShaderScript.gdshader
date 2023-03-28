shader_type canvas_item;
uniform sampler2D backbuffer_copy: hint_screen_texture;
void fragment() {
	COLOR.rgb = texture(backbuffer_copy, UV).rgb;
	COLOR.a = clamp(texture(TEXTURE, UV).a, 0.0, 1.0);
}
