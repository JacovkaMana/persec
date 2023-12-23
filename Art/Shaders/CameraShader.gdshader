shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D noise_texture;

uniform vec3 main_color: source_color = vec3(1.0, 0., 0.);
uniform float progress:  hint_range(0.0, 5.0) = 0.0;
uniform float scale:  hint_range(0.0, 2.) = 1.0;
uniform float size: hint_range(0.0, 500.0) = 100.0;
uniform float zoom: hint_range(0.0, 10.0) = 1.0;

uniform float speed: hint_range(0.0, 10.0) = 3.0;

struct Hole{
	vec2 Center;
    float Rad;
};

mat2 rotationMatrix(float angle)
{
	angle *= PI / 180.0;
    float sine = sin(angle);
	float cosine = cos(angle);
    return mat2( vec2(cosine, -sine), 
                 vec2(sine,    cosine) );
}

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
	float cosa = cos(rotation);
	float sina = sin(rotation);
	uv -= pivot;
	return vec2(
		cosa * uv.x - sina * uv.y,
		cosa * uv.y + sina * uv.x 
	) + pivot;
}

void fragment() {
	vec2 fragCoord = FRAGCOORD.xy;
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	float iTime = progress;
	
	
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.);
    vec3 col = vec3(1.0, 0.0, 0.0);
    float d = 0.;
    for (float i = 0.; i < 10.; i++) {
        uv = fract(uv * 1.) - .5;

        d = length(uv) * exp(-length(uv0));

        d = sin(d*8. + iTime)/8.;
        d = abs(d);

        d = pow(.001 / d, 3.0);

        finalColor += main_color * d;
    }

	float deep = progress / 3.2;

    COLOR = mix( texture(screen_texture, UV), vec4(finalColor, 1.0), deep);

}
