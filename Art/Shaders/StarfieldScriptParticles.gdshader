shader_type particles;

//this defines how far out the particles will spawn
uniform float particle_diameter = 5.0;


//input a value that changes over time and can also be a coordinate
//use vec(TIME,0) if you got no coordinates
float rand(vec2 co){
    //this will give a pseudorandom value between 0-1
    return fract(sin(dot(co.xy ,vec2(23.21,101.83))) * 34759.214);
}


void start()
	{
		
		//set the position to be randomly dispersed in an area
		float x_modifier = (rand(vec2(TIME,0))*particle_diameter);
		float z_modifier = (rand(vec2(TIME+1.0,0))*particle_diameter);
		
		//centers effect
		TRANSFORM[3][0] = x_modifier - 0.5f*particle_diameter;
		TRANSFORM[3][2] = z_modifier- 0.5f*particle_diameter;
		
		
		//VELOCITY.y = -rand(vec2(TIME+2f,0));
		VELOCITY.y = -1.0;
	}
	
void process(){
	//this sets all the stuff necesary
        //spawn them in a given radius around the emmitor
	//apply a changing wind that changes with time with a noticable variation
	VELOCITY.x = 3.0*sin(TIME/4.0)*sin(TIME)*rand(vec2(float(INDEX),0.0));
	VELOCITY.z = 3.0*cos(TIME/4.0)*cos(TIME)*rand(vec2(float(INDEX)+1.0,0.0));
	
	
	
	//gives a consistent rotation that depends on the index
	float x_rotation = TIME*rand(vec2(float(INDEX),0.0));
	float y_rotation = TIME*rand(vec2(float(INDEX)+1.0,0.0));
	float z_rotation = TIME*rand(vec2(float(INDEX)+2.0,0.0));
	
	
	
	//these just rotate the leaf using matrix math
	//x rotation
	TRANSFORM[1][1] = cos(x_rotation);
	TRANSFORM[2][1] = -sin(x_rotation);
	TRANSFORM[1][2] = sin(x_rotation);
	TRANSFORM[2][2] = cos(x_rotation);
	//y rotation
	TRANSFORM[0][0] = cos(y_rotation);
	TRANSFORM[2][0] = -sin(y_rotation);
	TRANSFORM[0][2] = sin(y_rotation);
	TRANSFORM[2][2] = cos(y_rotation);
	//z rotation
	TRANSFORM[0][0] = cos(z_rotation);
	TRANSFORM[1][0] = -sin(z_rotation);
	TRANSFORM[0][1] = sin(z_rotation);
	TRANSFORM[1][1] = cos(z_rotation);
	
}