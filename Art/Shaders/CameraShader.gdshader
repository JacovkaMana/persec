shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D noise_texture;
uniform float scale:  hint_range(0.0, 2.) = 1.0;
uniform float size: hint_range(0.0, 500.0) = 100.0;
struct Hole{
	vec2 Center;
    float Rad;
};

void fragment() {
    Hole MyHole;
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    MyHole.Center = vec2(iResolution.x /2.0 , iResolution.y /2.0);
    MyHole.Rad    = size;
    
    //Hole MyHole2;
    //MyHole2.Center = vec2(iResolution.x /2.0, iResolution.y /2.0);
    //MyHole2.Rad    = 100.0;
    
    
	vec2 uv = FRAGCOORD.xy / iResolution.xy;
	uv = UV;
 	//uv.y = -uv.y;
    
    //vec4 Vector = vec4(MyHole.Center,0.0, 1.0) - vec4(FRAGCOORD.xy,0,0);
    
    //float Distance = length(Vector);
    
        
    vec2 Vector = MyHole.Center - FRAGCOORD.xy;
    
    float Distance = length(Vector);
	
    if(Distance < MyHole.Rad)
    {
        float DistToRad = MyHole.Rad - Distance;
        
        Vector = normalize(Vector);
        
        vec2 CoordToUse = FRAGCOORD.xy - Vector.xy * DistToRad * scale;
        
        
        uv = CoordToUse/iResolution.xy;
        //uv.y = -uv.y;
        
    }
    
    
    COLOR = texture(screen_texture, uv);
}
