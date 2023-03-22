extends StaticBody2D

var start_pos: Vector2
var moving: bool = false
var direction: Vector2
var animation_tree: AnimationTree = null
var animation_player: AnimationPlayer = null
@onready var particles: GPUParticles2D = $Particles
@onready var sprite: Sprite2D = $Bullet
@onready var texture_light: PointLight2D = $TextureLight
@onready var light: PointLight2D = $PointLight


#@onready var particles = $GPUParticles2D
#@onready var state_machine = animation_tree.get("parameters/playback")

@export var move_speed : float = 100
@export var move_range: float
@export var moving_projectile: bool = false
@export var animated: bool = false
var projectile_owner = null

var skill = null
var collision_object = null
var test_color = preload("res://Art/Colors/Ice.tres")

@onready var SceneManager = self.get_tree().get_root().find_child("SceneManager", true, false)
# Called when the node enters the scene tree for the first time.
func _ready():
	
	start_pos = self.position
	if (animated):
		#animation_tree = $AnimationTree
		animation_player = $AnimationPlayer
		
		animation_player.connect("animation_finished", delete)
		animation_player.queue("Slash")
		
	
#	var bitmap = BitMap.new()
#	bitmap.create_from_image_alpha(sprite.texture.get_image())
#
#	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO,sprite.texture.get_size()))
#	for poly in polys:
#		var collision_polygon = CollisionPolygon2D.new()
#		collision_polygon.polygon = poly
#		self.add_child(collision_polygon)
#	
	print(move_speed)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if (moving):
		collision_object = move_and_collide(direction*_delta*move_speed)
		
		if( is_instance_valid(collision_object) and not collision_object.get_collider() == projectile_owner):
			if collision_object.get_collider().get_class() == 'CharacterBody2D':
				collision_object.get_collider().take_ranged_damage(skill, null)
				
				if (not moving_projectile):
					trigger_melee()
					
				self.queue_free()
			elif collision_object.get_collider().get_class() == 'TileMap':
				self.queue_free()

	
	
func shoot(where: Vector2, _animated: bool = false, who = null):
	#state_machine.travel("Start")
	moving = true
	direction = where.normalized()
	projectile_owner = who

		
	if (not _animated):
		particles.emitting = false
		
		
func change_sprite(_skill: BaseSkill):
	#to = skill.projectile
#	sprite.set_texture(to)
#	texture_light.set_texture(to)
	texture_light.color = RandomStats.type_colors[_skill.damage_type] # too many lights
	sprite.self_modulate = RandomStats.type_colors[_skill.damage_type]
	light.color = RandomStats.type_colors[_skill.damage_type]
	
	if (_skill.type == Enums.ESkillType.MAGIC):
		sprite.material = GlobalSkills.shaders[_skill.damage_type]
		particles.process_material.color_ramp = GlobalSkills.colors[_skill.damage_type]
	else:
		sprite.material = null
		particles.emitting = false

	#print(particles.emission_shape)
	#print(particles.process_material.emission_point_texture)
#	var im = to.get_image()
#	im.decompress()
#	#print(to.get_image().get_data())
#	var msize = im.get_size()
#	var emiss = []
#	for i in range(0, msize.x):
#		for j in range(0, msize.y):
#				if im.get_pixel(i,j).a > 0:
#					#print(im.get_pixel(i,j).a)
#					emiss.push_back(Vector2(i,j))
#	particles.set_emission_points(emiss)
	
func delete(_anim):
	print('delete triggered')
	self.queue_free()

func trigger_melee():
	SceneManager.add_melee()
	
	
