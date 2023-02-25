extends CharacterBody2D
class_name Actor

@export var move_speed : float = 100.0
@export var starting_direction : Vector2 = Vector2(0, 1)
@export var move_direction: Vector2 = Vector2(0,0)
@onready var animation_tree = $AnimationTree
@onready var label = $HeadLabel
@onready var sprite = $Sprite
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var Projectiles: Node2D = self.get_tree().get_root().find_child("Projectiles", true, false)
var data = PlayerData.new()
var asd: ParticleProcessMaterial
@export var walking = true
var last_move
var head_timer

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
	walking = velocity != Vector2.ZERO
	
func _physics_process(_delta):
	update_animation_parameters(move_direction)
	velocity = move_direction * move_speed * _delta
	#move_and_slide()
	move_and_collide(velocity)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		#print("I collided with ", collision)
	pick_new_state();
	
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
	
	print(skill.name)
	bullet.skill = skill
	
	bullet.change_sprite(skill)		
	bullet.global_position = self.global_position
	bullet.rotation = bullet_rotation.angle() + PI/2
	if (bullet.moving_projectile):
		bullet.shoot(bullet_rotation, true, self)
	else:
		bullet.shoot(Vector2(0,0), true, self)
	
func take_damage(skill: BaseSkill, strength):
	data.hitpoints -= 20
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
