extends CharacterBody2D
class_name Actor

@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var label = $HeadLabel
@onready var sprite: Sprite2D = $Sprite
@onready var cloak: Sprite2D = $Cloak
@onready var face: Sprite2D = $Face
@onready var interaction_area: Area2D = $InteractionArea
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var Projectiles: Node2D = self.get_tree().get_root().find_child("Projectiles", true, false)

@export var move_speed : float = 100.0
@onready var data = PlayerData.new()
@export var walking = false

var asd: ParticleProcessMaterial
var last_move
var head_timer
var collision
var current_zone : Area2D
var starting_direction : Vector2 = Vector2(0, 1)
var move_direction: Vector2 = Vector2(0,0)

func _ready():
	update_animation_parameters(starting_direction)
	
	
	animation_tree.connect("animation_finished", _on_anim_finished)
	
	#animation_player.connect("animation_finished", _on_anim_finished)
	
	animation_tree.set("parameters/walking/current_state", "walking")


func update_animation_parameters (move_input : Vector2):
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

	if move_input.x < 0:
		sprite.flip_h = true
		cloak.flip_h = true
		face.flip_h = true
	elif move_input.x > 0:
		sprite.flip_h = false
		cloak.flip_h = false
		face.flip_h = false


func _process(delta):
	if (self.data.stamina < self.data.max_stamina):
		self.data.stamina += delta * self.data.stamina_regen / 20.0
		if (self.data.stamina > self.data.max_stamina):
			self.data.stamina = self.data.max_stamina

	
func _physics_process(_delta):
	update_animation_parameters(move_direction)
	velocity = move_direction * move_speed * _delta
	#move_and_slide()
	collision = move_and_collide(velocity)

	walking = velocity != Vector2.ZERO
	if	walking:
		animation_tree.set("parameters/walking/transition_request", "walking")	
		animation_tree.set("parameters/walking_speed/scale", 1)
	else:
		animation_tree.set("parameters/walking/transition_request", "idle")
	
	if (head_timer):
		label.text = "%.2f" % (head_timer.time_left)
		
	
func use_skill_id(id: int):
	if id < data.skills.get_skills().size():
		shoot_projectile(
			data.skills.get_skill_id(id)
		)
	
func shoot_projectile(skill: BaseSkill) -> void:
	var proj = skill.projectile
	var bullet = proj.instantiate()
	var bullet_rotation = ( get_global_mouse_position() - self.global_position ).normalized()

	if (bullet.moving_projectile):
		Projectiles.add_child(bullet)
	else:
		self.add_child(bullet)
	
	#bullet.create_shape_owner(self)
	bullet.add_collision_exception_with(self)
	
	bullet.skill = skill
	
	bullet.change_sprite(skill)		
	bullet.global_position = self.global_position
	bullet.rotation = bullet_rotation.angle() + PI/2
	if (bullet.moving_projectile):
		bullet.shoot(bullet_rotation, true, self)
	else:
		bullet.shoot(Vector2(0,0), true, self)
	
func take_ranged_damage(_skill: AttackSkill, from: Actor,_strength):
	data.hitpoints -= int(_skill.ranged_damage * from.get_damage() / 100.0)
	print(int(_skill.ranged_damage * from.get_damage() / 100.0))
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

func _on_anim_finished(name):
	pass


func get_damage():
	if	data.inventory.get_equipments_slot(Enums.EEquipmentSlot.R_HAND):
		return data.inventory.get_equipments_slot(Enums.EEquipmentSlot.R_HAND).get_flat_damage()
	else:
		return data.stats[Enums.EStat.STRENGTH]
