extends CharacterBody2D
class_name Actor

@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var label = $HeadLabel
#@onready var sprite: Sprite2D = $Sprite
#@onready var cloak: Sprite2D = $Cloak
#@onready var face: Sprite2D = $Face
@onready var interaction_area: Area2D = $InteractionArea
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var Projectiles: Node2D = self.get_tree().get_root().find_child("NeutralProjectiles", true, false)
@onready var Stationary_Projectiles: Node2D = $Projectiles
@onready var hitbox = $HitBox
@onready var area_tracker: Area2D = $AreaTracker

@export var move_speed : float = 100.0

var animatable_arts: Array[Sprite2D] = []
var data: PlayerData# = PlayerData.new()
var walking = false

@onready var Statuses = $Statuses


var in_skill_animation: bool = false
var asd: ParticleProcessMaterial
var last_move
var head_timer
var collision

var current_zone : Area2D
var current_zone_shape: Rect2

var starting_direction : Vector2 = Vector2(0, 1)
var move_direction: Vector2 = Vector2(0,0)

var freeze: bool = false

var look_at: Node2D = null

func _ready():
	if not (data):
		data = PlayerData.new()
	update_animation_parameters(starting_direction, Vector2(0.,0.))
	
	area_tracker.connect('area_entered', _on_area_entered)
	animation_tree.connect("animation_finished", _on_anim_finished)
	
	#animation_player.connect("animation_finished", _on_anim_finished)
	
	animation_tree.set("parameters/walking/current_state", "walking")
	
	
	for one in self.get_children():
		if one is Sprite2D:
			animatable_arts.append(one)
	
	
	

func update_animation_parameters (direction: Vector2, _velocity):
	#print(move_input == Vector2.LEFT)
	#if (move_input != Vector2.ZERO):
		#animation_tree.set("parameters/Walk/blend_position",move_input)
		#animation_tree.set("parameters/Idle/blend_position",move_input)
		#pass
	animation_tree.set("parameters/walking/transition_request", "walking")
#	if (last_move != move_input):
#		match (move_input):
#			Vector2.LEFT:
#				state_machine.travel("idle_left")
#			Vector2.RIGHT:
#				state_machine.travel("idle_right")
#			Vector2.UP:
#				state_machine.travel("idle_up")
#			Vector2.DOWN:
#				state_machine.travel("idle_down")
#		last_move = move_input

	if direction.x < 0:
		
		for one in animatable_arts:
			one.flip_h = true
	elif direction.x > 0:
		for one in animatable_arts:
			one.flip_h = false
	
	walking = (abs(_velocity.x) <= 0.0001 and abs(_velocity.y) <= 0.0001)
			
			
	if	walking:
		animation_tree.set("parameters/walking/transition_request", "walking")	
		animation_tree.set("parameters/walking_speed/scale", 1)
	else:
		animation_tree.set("parameters/walking/transition_request", "idle")


#func _process(delta):
#	if (self.data.stamina < self.data.max_stamina):
#		self.data.stamina += delta * self.data.stamina_regen / 20.0
#		if (self.data.stamina > self.data.max_stamina):
#			self.data.stamina = self.data.max_stamina

	
func _physics_process(_delta):
	if freeze:
		return 2
		
		
	if (self.data.stamina < self.data.max_stamina):
		self.data.stamina += _delta * self.data.stamina_regen / 20.0
		if (self.data.stamina > self.data.max_stamina):
			self.data.stamina = self.data.max_stamina
			
			
	velocity = move_direction * move_speed * _delta
	if (look_at):
		update_animation_parameters(Vector2(look_at.position - self.position), velocity)
	else:
		update_animation_parameters(move_direction, velocity)
	#move_and_slide()
	collision = move_and_collide(velocity)
	
	if (head_timer):
		label.text = "%.2f" % (head_timer.time_left)
		
	
func use_skill_id(id: int):
	if id < data.skills.get_skills().size():
		
		match data.skills.get_skill_id(id).get_skill_type(): 
			'Attack':
				shoot_projectile( data.skills.get_skill_id(id))
			'Status':
				use_status_skill( data.skills.get_skill_id(id))



func _on_area_entered(_area : Area2D):
	pass
#	print(area.name)
#	print(area.shape_owner_get_owner(0) )

func shoot_projectile(skill: Skill, at: CharacterBody2D = null) -> void:
	var proj = skill.projectile
	var bullet = proj.instantiate()
	var damage_type = skill.damage_type
	var skill_type = skill.type
	
	
	if skill.type == Enums.ESkillType.MELEE:
		if Enums.EStatus.FIRE_WEAPON in data.statuses:
			damage_type = Enums.EDamageType.FIRE
			print('fire branding make more optimized')
			skill_type = Enums.ESkillType.MAGIC
	
	match bullet.get_collider_type():
		'Projectile':
			#var bullet = proj.instantiate()
			var bullet_rotation
			if (at):
				bullet_rotation = ( at.global_position - self.global_position ).normalized()
			else:
				bullet_rotation = ( get_global_mouse_position() - self.global_position ).normalized()
				
			if skill.type == Enums.ESkillType.MAGIC:
				bullet.magic == true
			
				

			if (bullet.moving_projectile):
				Projectiles.add_child(bullet)
			else:
				Stationary_Projectiles.add_child(bullet)
			
			#bullet.create_shape_owner(self)
			bullet.add_collision_exception_with(self)
			bullet.add_collision_exception_with(hitbox)
			
			bullet.skill = skill
			
			bullet.change_sprite(damage_type, skill_type)		
			bullet.global_position = self.global_position
			bullet.rotation = bullet_rotation.angle() + PI/2
			if (bullet.moving_projectile):
				bullet.shoot(bullet_rotation, true, self)
			else:
				bullet.shoot(Vector2(0,0), true, self)
				
		'Aura':
			pass

		
	
func take_damage(_skill: Skill, from: Actor, _strength):
	data.hitpoints -= int(_skill.damage_value * from.get_attack() / 100.0)
	#print(int(_skill.ranged_damage * from.get_damage() / 100.0))
	self.modulate = Color8(255,0,0,255)
	
	cooldown(1)

func reset_after_hit():
	self.modulate = Color8(255,255,255,255)
	label.visible = false
	head_timer = null

func cooldown(time):
	head_timer = Timer.new()
	label.visible = true


	head_timer.set_wait_time(time)
	head_timer.set_one_shot(true)
	head_timer.connect("timeout", reset_after_hit)  
	add_child(head_timer)
	head_timer.start()
	

func set_zone(to):
	current_zone = to

func _on_anim_finished(_name):
	pass


func get_attack():
	if	data.inventory.get_equipments_slot(Enums.EEquipmentSlot.R_HAND):
		return data.inventory.get_equipments_slot(Enums.EEquipmentSlot.R_HAND).get_flat_damage()
	else:
		return data.stats[Enums.EStat.STRENGTH]
		
	
		
func use_status_skill(skill: Skill):
	
	if (skill.self_status):
			self.initiate_status(skill, skill.self_status, skill.status_duration)



func initiate_status(skill: Skill, status: Enums.EStatus, duration: int):
	if status == Enums.EStatus.NONE:
		return 0 
		
	var status_timer =  ( self.data.add_status( status, duration) )
	if (status_timer):

		self.add_child(status_timer)

		#self.Statuses.show_status(skill.self_status)
	print(Enums.EStatus.find_key(status))
	match status:
			null:
				pass
			Enums.EStatus.DEFEND:
				self.Statuses.show_status(status)
			Enums.EStatus.SHIELD:
				self.Statuses.shield(skill, status, duration, data.stats[Enums.EStat.INTELLIGENCE] * 10.0)
			Enums.EStatus.FIRE_WEAPON:
				self.Statuses.show_status(status)
#
	status_timer.timeout.connect( self.Statuses.hide_status.bind(status) ) 
	
	
	status_timer.start()


