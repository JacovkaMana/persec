extends StaticBody2D

var start_pos: Vector2
var moving: bool = false
var direction: Vector2
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

@export var move_speed : float = 30 
@export var range: float
# Called when the node enters the scene tree for the first time.
func _ready():
	
	start_pos = self.position
	#print(animation_player)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (moving):
		var collision_object = move_and_collide(direction*delta*move_speed)
		if( is_instance_valid(collision_object)):
			print(collision_object.get_collider())
			#print(move_and_collide(direction*delta*move_speed))
			self.queue_free()
	
	
	#if( move_and_collide(direction*delta*move_speed):
		#print('Collision 4')
	
func shoot(where: Vector2, speed:= 30):
	state_machine.travel("Start")
	moving = true
	direction = where
	move_speed = speed
