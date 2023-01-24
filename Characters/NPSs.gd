extends CharacterBody2D

enum NPS_STATE { IDLE, WALK }
  
@export var move_speed : float = 30 
@export var walk_radius: float = 50
var last_direction_change: float = 0

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

var move_direction : Vector2 = Vector2.ZERO
var current_state : NPS_STATE = NPS_STATE.IDLE
var start_pos: Vector2 = Vector2.ZERO

const Bullet = preload("res://bullet.tscn")
var Projectiles: Node2D = null


func _ready():
	

	
	Projectiles = self.get_tree().get_root().get_node("game_level").find_child("Projectiles")
	#print(Projectiles)
	
	start_pos = self.position
	
	# Create a timer node
	var timer = Timer.new()

	# Set timer interval
	timer.set_wait_time(5)

	# Set it as repeat
	timer.set_one_shot(false)

	# Connect its timeout signal to the function you want to repeat
	#timer.connect("timeout", self, "random_direction")
	timer.connect("timeout", random_direction)

	# Add to the tree as child of the current node
	add_child(timer)

	timer.start()
	

func _physics_process(_delta):
	velocity = move_direction * move_speed
	move_and_slide() 
	#print(self.global_position)
	#if ( start_pos.distance_to(self.position) > walk_radius):
	#	select_new_direction()
		
func random_direction() -> void:
	#move_direction = Vector2(randi_range(-1,1), randi_range(-1,1))
	last_direction_change = Time.get_ticks_msec()
	#print('random')
	
	var parent = self.get_parent()
	var bullet = Bullet.instantiate()
	var bullet_rotation = Vector2(randi_range(-1,1), randi_range(-1,1))
	bullet.global_position = self.global_position
	bullet.rotation = bullet_rotation.angle() + PI/2
	print(bullet_rotation.angle())
	Projectiles.add_child(bullet)

	bullet.shoot(bullet_rotation, randi_range(50,100))




func pick_new_state():
	if (current_state == NPS_STATE.IDLE):
		state_machine.travel("Walk")
		current_state = NPS_STATE.WALK
	elif(current_state == NPS_STATE.WALK):
		state_machine.travel("Idle")
		current_state = NPS_STATE.Idle
