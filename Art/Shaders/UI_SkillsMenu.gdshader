shader_type canvas_item;

uniform vec4 color : source_color = vec4(0.976, 0.447, 0.023, 1);
uniform float x_move;
uniform float y_move;
uniform float progress : hint_range(0, 100);
uniform sampler2D image : source_color;

float alchemicalSymbol( vec2 p, vec4 type )
{
    // Just making up some imaginary symbols
    // Inspired by stuff like:
    // https://en.wikipedia.org/wiki/Alchemical_symbol
    // https://en.wikipedia.org/wiki/Astrological_symbols
    
    // Orientation
    if(type.w < 0.5)
        p.y = -p.y;
    
    vec2 chargeCenter = vec2(0);
    float d = 100.;
    
    float nBase = 4.5;
    float nCharge = 4.;
    float nAdj = 4.;
    type.xyz *= vec3(1.2*nBase, 2.0*nCharge, 2.0*nAdj);
    
    if(type.z < nAdj && type.x < nBase) 
        // If we have a base and adjunction, shift the symbol
    	p -= vec2(0., 0.618);
    if(type.x >= nBase)
    {
        // If we have no base, make sure we have a charge (most of the time)
        // and no adjunction
        type.y *= 0.6;
        type.z = nAdj;
    }
    
    // Base symbol
    if(type.x < 1.)
    {
        // Circle
        d = min(d, abs(length(p) - 1.0));
    }
    else if(type.x < 2.)
    {
        // Triangle
        vec2 q = p;
        if(fract(type.x) >= 0.5)
        {
            // Down triangle
            chargeCenter = vec2(0, 1./3.);
            q = -p+chargeCenter;
        }
        else
        {
            // Up triangle
        	chargeCenter = vec2(0, -1./3.);
            q = p-chargeCenter;
        }
        q.x = abs(q.x);
        vec2 q2 = reflect(q, vec2(1./2., sqrt(3.)/2.));
        q = q2.y < q.y ? q2 : q;
        
        q.y += 2./3.;
        d = min(d, length(max(abs(q)-vec2(2./sqrt(3.),0.), 0.)));
    }
    else if(type.x < 3.)
    {
        // Diamond
        vec2 q = abs(p);
        q = sqrt(0.5) * vec2(q.x+q.y, q.x-q.y);
        q.x -= sqrt(.5);
        d = min(d, length(max(abs(q)-vec2(0.,sqrt(.5)), 0.)));
    }
    else if(type.x < 4.)
    {
        // Moon
        float orientation = floor(3.0*(type.x-3.));
        vec2 q = p;
        if(orientation < 1.)
        {
            q = p.yx;
            chargeCenter += vec2(0.5*0.618, 0.);
        }
        else if(orientation < 2.)
        {
            q = p;
        	chargeCenter += vec2(0., 0.5*0.618);
        }
        else
        {
            q = -p.yx;
            chargeCenter += vec2(-0.5*0.618, 0.);
        }
        vec2 tip = vec2(0.618,sqrt(1.-0.618*0.618));
        q = vec2(abs(q.x), q.y);
        float d1 = (-q.x*tip.y+q.y*tip.x > 0.) ? length(q-tip) : abs(length(q) - 1.0);
        d = min(d, d1);
        q -= vec2(0., 0.5*0.618);
        tip -= vec2(0., 0.5*0.618);
        d1 = (-q.x*tip.y+q.y*tip.x > 0.) ? length(q-tip) : abs(length(q) - length(tip));
        d = min(d, d1);
    }
    else if(type.x < 4.5)
    {
        // 4. "Ascending/descending node" - Omega
        vec2 q = p;
        float r0 = 1.1;
        float w1 = 0.6;
        float r1 = 0.5*0.618;
        vec2 tip = r0*vec2(w1,sqrt(1.-w1*w1));
        float orientation = (type.x < 4.5) ? 1.0 : -1.0;
        chargeCenter = vec2(0,-(1.0-r0+r1)*orientation);
        vec2 q0 = vec2(q.x, q.y*orientation+(1.0-r0+r1));
        q = vec2(abs(q0.x), q0.y);
        bool b = (-q.x*tip.y+q.y*tip.x > 0.);
        float d1 = b ? length(q-tip) : abs(length(q) - r0);
        d1 = abs(d1 - r1);
        vec2 tip2 = tip * (r0+r1)/r0;
        //d1 = max(d1, length(q-tip2));
        
        float l = length(q);
        if(l > 1. && !b)
        {
            d1 = min(l-(1.-r1), length(q - tip2));
        }
        
        d = min(d, d1);
    }
    
    // Charge layered onto the symbol
    if(type.y < 1.)
    {
        // Horizontal stroke
        p.xy = type.x < nBase ? p.xy : p.yx;
        d = min(d, length(max(abs(p)-vec2(1.,0.), 0.)));
    } 
	else if(type.y < 2.)
    {
        // "Sun" dot
        d = min(d, length(p-chargeCenter)-0.15);
    }
    else if(type.y < 3.)
    {
        // "Sextile" / asterisk
        vec2 q = abs(p - chargeCenter).yx;
        vec2 q2 = reflect(q, vec2(-0.5, sqrt(3.)/2.));
        q = (q2.y < q.y) ? q2 : q;
        d = min(d, length(max(abs(q) - vec2(0.618*0.5,0), 0.)));
    }
    else if(type.y < 4.)
    {
        // Small triangle
        vec2 q = (p-chargeCenter)*sign(fract(type.y)-0.5);
        q.x = abs(q.x);
        vec2 q2 = reflect(q, vec2(1./2., sqrt(3.)/2.));
        q = q2.y < q.y ? q2 : q;
    	// When applicable, make it a triforce
        float size = (1.5 < type.x && type.x < 2.0) ? 1. : 0.5;
        q.y += size/3.;
        d = min(d, length(max(abs(q)-vec2(size/sqrt(3.),0.), 0.)));
    }
    
    // Adjonction below the symbol
    vec2 q = p - vec2(0,-1.618);
    if(type.z < 1.)
    {
        // "Venus" cross
        q = abs(q);
        q.xy = q.x < q.y ? q.xy : q.yx;
        d = min(d, length(max(abs(q)-vec2(0.,0.618), 0.)));
    }
    else if(type.z < 2.)
    {
        // "Mars" arrow
        q.x = abs(q.x);
        d = min(d, length(max(abs(q)-vec2(0.,0.618),0.)));
        q.y += 0.618;
        q.xy = sqrt(0.5) * vec2(q.x+q.y, q.x-q.y);
        q.x -= 0.5*0.618;
        d = min(d, length(max(abs(q)-vec2(0.5*0.618,0.),0.)));
    }
    else if(type.z < 3.)
    {
        // "Mercury" wings
        q = vec2(abs(q.x), -q.y);
        vec2 tip = 0.618*vec2(0.618,sqrt(1.-0.618*0.618));
        float d1 = (-q.x*tip.y+q.y*tip.x > 0.) ? length(q-tip) : abs(length(q) - length(tip));
        d = min(d, d1);
    }
    else if(type.z < 4.)
    {
        // Double underline, 'cause why not?
        q = abs(q) - vec2(0, 0.618*1./3.);
        d = min(d, length(max(abs(q) - vec2(0.618,0.), 0.)));
    }
    return d;
}

vec4 hash42(vec2 p)
{
    vec4 p4 = fract(vec4(p.xyxy) * vec4(161.1031, 144.1030, 153.0973, 166.1099));
    p4 += dot(p4, p4.wzxy + 33.33);
    return fract((p4.xxyz + p4.yzzw) * p4.zywx);
}

void fragment()
{
	vec2 iResolution = vec2(640.0, 360.0);
	vec2 fragCoord = vec2(FRAGCOORD.x, iResolution.y - FRAGCOORD.y);
    vec2 uv = (2.*fragCoord - iResolution.xy)/iResolution.y;

    #if 0
    // DEBUG
    uv *= 3.0;
    float d = alchemicalSymbol(uv, vec4(0.7,0.9,0.9,0.5));
    // For debugging distance field:
    vec3 col = vec3(fract(10.0*(d))) * smoothstep(1.5, 0.0, d);
    
    
    #else
    
	//float th = 0.2*sin(TIME*0.3);
	//uv *= mat2(vec2(cos(th),sin(th)), vec2(-sin(th),cos(th)));
	//uv *= mat2(vec2(cos(th),sin(th)), vec2(-sin(th),cos(th)));
    uv += vec2(x_move, y_move);
    uv *= 10.0;
    vec2 scale = vec2(0.66*4.0, 4.5);
    vec2 uv_c = scale*round(uv/scale);
    vec2 p = uv - uv_c;
    
	float d = alchemicalSymbol(p, hash42(uv_c));
    
    // Add horizontal lines
    d = min(d, abs(abs(p.y) - 0.5*scale.y + 0.2));
    float thickness = 0.08;
    
    // Antialias
    float dth = 0.7*length(fwidth(uv));
    float x = smoothstep(thickness+dth,thickness-dth, d);
    vec3 col = vec3(x-.4, x-.4, x-.4);
    
    /*
	float d1 = max(d,0.);
    float x2 = d < thickness ? 1.0 - d1*d1/(thickness*thickness) : 0.;
    
    vec2 nxy = vec2(dFdx(x2), dFdy(x2)) * iResolution.y / 300.;
    vec3 n = vec3(nxy, sqrt(1.-nxy.x*nxy.x-nxy.y*nxy.y));
    //col = 0.5 + 0.5*n;
    vec3 sun = normalize(vec3(1.,1.,2.));
    
    vec3 col = texture(iChannel0, uv*0.05,0.).rgb;
    col = mix(col, vec3(1.), texture(iChannel0, uv.yx*0.05, 2.5).rgb);
    col = mix(col, pow(clamp(dot(n,sun),0.,1.),10.)+vec3(0.), x);
    */
	
    #endif
    
    // Output to screen
    COLOR = vec4(col,1.0);
}