extends CharacterBody2D
class_name Actor


@export var move_speed : float = 100 
@export var starting_direction : Vector2 = Vector2(0, 1)
@export var move_direction: Vector2 = Vector2(0,0)
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var Projectiles: Node2D = self.get_tree().get_root().get_node("game_level").find_child("Projectiles")
const Bullet = preload("res://bullet.tscn")
var data = PlayerData.new()
var asd: ParticleProcessMaterial

func _ready():
	update_animation_parameters(starting_direction)




func update_animation_parameters (move_input : Vector2):
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position",move_input)
		animation_tree.set("parameters/Idle/blend_position",move_input)
		
func pick_new_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
		

	
func _physics_process(_delta):
	update_animation_parameters(move_direction)
	velocity = move_direction * move_speed 
	move_and_slide()
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
	print(skill.projectile)
	
	
	bullet.change_sprite(skill.projectile, skill)
	

		
	bullet.global_position = self.global_position
	bullet.rotation = bullet_rotation.angle() + PI/2
	bullet.shoot(bullet_rotation, 100, true)
