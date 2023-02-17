extends CharacterBody2D
class_name Actor

@export var hitpoints: float = 100.0
@export var move_speed : float = 100.0
@export var starting_direction : Vector2 = Vector2(0, 1)
@export var move_direction: Vector2 = Vector2(0,0)
@onready var animation_tree = $AnimationTree
@onready var label = $Label
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var Projectiles: Node2D = self.get_tree().get_root().get_node("game_level").find_child("Projectiles")
const Bullet = preload("res://bullet.tscn")
var data = PlayerData.new()
var asd: ParticleProcessMaterial
@export var walking = true
var last_move

func _ready():
	update_animation_parameters(starting_direction)
	state_machine.travel("Start")
	#state_machine.travel("idle_bot")



func update_animation_parameters (move_input : Vector2):
	#print(move_input == Vector2.LEFT)
	#if (move_input != Vector2.ZERO):
		#animation_tree.set("parameters/Walk/blend_position",move_input)
		#animation_tree.set("parameters/Idle/blend_position",move_input)
		#pass
	if (last_move != move_input):
		match (move_input):
			Vector2.LEFT:
				state_machine.travel("idle_left")
			Vector2.RIGHT:
				state_machine.travel("idle_right")
			Vector2.UP:
				state_machine.travel("idle_up")
			Vector2.DOWN:
				state_machine.travel("idle_down")
		last_move = move_input
		
func pick_new_state():
	if (velocity != Vector2.ZERO):
		walking = true
	else:
		walking = false
		

	
func _physics_process(_delta):
	update_animation_parameters(move_direction)
	velocity = move_direction * move_speed * _delta
	#move_and_slide()
	move_and_collide(velocity)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		#print("I collided with ", collision)
	pick_new_state();
	

	
func use_skill_id(id: int):
	if id < data.skills.get_skills().size():
		shoot_projectile(
			data.skills.get_skill_id(id)
		)
	
func shoot_projectile(skill: BaseSkill) -> void:
	
	var bullet = Bullet.instantiate()
	var bullet_rotation = ( get_global_mouse_position() - self.global_position ).normalized()


	Projectiles.add_child(bullet)
	
	
	print(skill.name)
	
	
	bullet.change_sprite(skill.projectile, skill)
	

		
	bullet.global_position = self.global_position
	bullet.rotation = bullet_rotation.angle() + PI/2
	bullet.shoot(bullet_rotation, 100, true)
	
func take_damage(skill: BaseSkill, strength):
	hitpoints -= 20
	self.modulate = Color8(255,0,0,255)
	
	var invincible_timer = Timer.new()
	label.text = '20'
	label.visible = true


	invincible_timer.set_wait_time(1)
	invincible_timer.set_one_shot(true)
	invincible_timer.connect("timeout", reset_after_hit)  
	add_child(invincible_timer)
	invincible_timer.start()

func reset_after_hit():
	self.modulate = Color8(255,255,255,255)
	label.visible = false
