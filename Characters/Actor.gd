extends CharacterBody2D
class_name Actor


@export var move_speed : float = 100 
@export var starting_direction : Vector2 = Vector2(0, 1)
@export var inventory: Inventory = Inventory.new()
@export var move_direction: Vector2 = Vector2(0,0)
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")



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
