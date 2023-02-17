extends StaticBody2D

var start_pos: Vector2
var moving: bool = false
var direction: Vector2
@onready var animation_tree = $AnimationTree
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var sprite: Sprite2D = $Bullet
@onready var texture_light: PointLight2D = $TextureLight
@onready var light: PointLight2D = $PointLight2D
@onready var collision: CollisionPolygon2D = $CollisionPolygon2D
#@onready var particles = $GPUParticles2D
@onready var state_machine = animation_tree.get("parameters/playback")

@export var move_speed : float = 30 
@export var range: float

var test_color = preload("res://Art/Colors/Ice.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	start_pos = self.position

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (moving):
		var collision_object = move_and_collide(direction*delta*move_speed)
		if( is_instance_valid(collision_object)):
			if collision_object.get_collider().get_class() == 'CharacterBody2D':
				collision_object.get_collider().take_damage(null, null)
				self.queue_free()
			elif collision_object.get_collider().get_class() == 'TileMap':
				self.queue_free()
			#print(move_and_collide(direction*delta*move_speed))
			#self.queue_free()
	
	
	#if( move_and_collide(direction*delta*move_speed):
		#print('Collision 4')
	
func shoot(where: Vector2, speed:= 30, animated: bool = false):
	#state_machine.travel("Start")
	moving = true
	direction = where
	move_speed = speed
	if (not animated):
		particles.visible = false
		
		
func change_sprite(to: CompressedTexture2D, skill: BaseSkill):
	sprite.set_texture(to)
	texture_light.set_texture(to)
	texture_light.color = RandomStats.type_colors[skill.damage_type]
	light.color = RandomStats.type_colors[skill.damage_type]
	
	if (skill.type == Enums.ESkillType.MAGIC):
		sprite.material = GlobalSkills.shaders[skill.damage_type]
		particles.color_ramp = GlobalSkills.colors[skill.damage_type]
	else:
		sprite.material = null
		particles.visible = false

	#print(particles.emission_shape)
	#print(particles.process_material.emission_point_texture)
	var im = to.get_image()
	im.decompress()
	#print(to.get_image().get_data())
	var msize = im.get_size()
	var emiss = []
	for i in range(0, msize.x):
		for j in range(0, msize.y):
				if im.get_pixel(i,j).a > 0:
					#print(im.get_pixel(i,j).a)
					emiss.push_back(Vector2(i,j))
	particles.set_emission_points(emiss)
	


	#particles.process_material.set_emission_point_texture(emiss)
	#particles.process_material.set_emission_normal_texture(emiss)
