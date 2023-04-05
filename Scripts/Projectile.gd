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
@onready var player = get_tree().get_root().find_child("Player", true, false)


#@onready var particles = $GPUParticles2D
#@onready var state_machine = animation_tree.get("parameters/playback")

@export var move_speed : float = 100
@export var move_range: float
@export var moving_projectile: bool = false
@export var animated: bool = false
@export var magic: bool = false
var projectile_owner = null

var skill = null
var collision_object = null
var test_color = preload("res://Art/Colors/Ice.tres")
var tween

@onready var SceneManager = self.get_tree().get_root().find_child("SceneManager", true, false)
# Called when the node enters the scene tree for the first time.
func _ready():
	
	start_pos = self.position
	if (animated):
		#animation_tree = $AnimationTree
		animation_player = $AnimationPlayer
		
		animation_player.connect("animation_finished", delete)
		animation_player.queue("Start")
		
#	if (magic):
#		particles.visible = true
#	else:
#		particles.visible = false

#	var bitmap = BitMap.new()
#	bitmap.create_from_image_alpha(sprite.texture.get_image())
#
#	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO,sprite.texture.get_size()))
#	for poly in polys:
#		var collision_polygon = CollisionPolygon2D.new()
#		collision_polygon.polygon = poly
#		self.add_child(collision_polygon)
#	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if (moving):
		collision_object = move_and_collide(direction*_delta*move_speed)
		if is_instance_valid(collision_object):
			print( collision_object.get_collider() )
			match collision_object.get_collider().name:
				projectile_owner.name:
					self.add_collision_exception_with(projectile_owner)
				'HitBox':
					if collision_object.get_collider().get_parent() == self.projectile_owner:
						self.add_collision_exception_with(collision_object.get_collider())
					match skill.get_skill_type(): 
						'Attack':
							collision_object.get_collider().get_parent().take_ranged_damage(skill, projectile_owner, null)
					self.queue_free()
				'TileMap':
					self.queue_free()
				_:
					if collision_object.get_collider().projectile_owner == self.projectile_owner:
						self.add_collision_exception_with(collision_object.get_collider())
					else:
						self.queue_free()
	else:
		collision_object = move_and_collide(direction*_delta*move_speed)
		if (projectile_owner == player):
			self.rotation = ( get_global_mouse_position() - projectile_owner.global_position ).normalized().angle() + PI/2
		else:
			self.rotation = ( player.global_position - projectile_owner.global_position ).normalized().angle() + PI/2
			
			
		if is_instance_valid(collision_object):
			match collision_object.get_collider().name:
				projectile_owner.name:
					self.add_collision_exception_with(projectile_owner)
				'HitBox':
					match skill.get_skill_type(): 
						'Attack':
							collision_object.get_collider().get_parent().take_ranged_damage(skill, projectile_owner, null)
							print('trigger_melee')
							#trigger_melee()
					self.queue_free()
				'TileMap':
					pass
				_:
					if collision_object.get_collider().projectile_owner == self.projectile_owner:
						self.add_collision_exception_with(collision_object.get_collider())
					else:
						collision_object.get_collider().queue_free()
		
	
	
func shoot(where: Vector2, _animated: bool = false, who = null):
	
	var where_y = Vector2(cos(self.rotation + PI/2), sin(self.rotation + PI/2))
	#var where_x = Vector2(cos(self.rotation), sin(self.rotation))
	#state_machine.travel("Start")
	if (where == Vector2.ZERO):
		particles.process_material.direction = Vector3(where_y.x * 10.0,where_y.y * -10.0 ,0)
		#self.position =- (where_y * 25.0)
		moving = false
	else:
		moving = true
		
	direction = where.normalized()
	projectile_owner = who
	
	
	
		
#		var target_position = self.global_position - (where_y * 10.0)
#		print(target_position)
#		if tween:
#			tween.kill() # Abort the previous animation.
#		tween = create_tween()
#		tween.tween_property(self, "global_position", target_position, 0.5)
#		tween.finished.connect(delete)

		
		
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
		#sprite.self_modulate.a = 150
		particles.emitting = true
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
	#print('delete triggered')
	print('delete')
	self.queue_free()

func trigger_melee():
	SceneManager.add_melee()
	
	
