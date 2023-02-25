extends Actor

enum NPS_STATE { IDLE, WALK }
  
@export var walk_radius: float = 50
var last_direction_change: float = 0


var current_state : NPS_STATE = NPS_STATE.IDLE
var start_pos: Vector2 = Vector2.ZERO


var select_material = preload("res://Art/Shaders/HighlightShader.tres")


func _ready():
	
	#self.connect("mouse_entered", _mouse_entered)
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)

	start_pos = self.position
	
	# Create a timer node
	var timer = Timer.new()

	# Set timer interval
	timer.set_wait_time(5)

	# Set it as repeat
	timer.set_one_shot(false)


	#timer.connect("timeout", random_direction)  SHOOT PEOPLE

	# Add to the tree as child of the current node
	add_child(timer)

	timer.start()
	

func _physics_process(_delta):
	super(_delta)
	
func random_direction() -> void:
	#move_direction = Vector2(randi_range(-1,1), randi_range(-1,1))
	last_direction_change = Time.get_ticks_msec()
	#print('random')
	
#	var parent = self.get_parent()
#	var bullet = Bullet.instantiate()
#	var bullet_rotation = Vector2(randi_range(-1,1), randi_range(-1,1))
#	bullet.global_position = self.global_position
#	bullet.rotation = bullet_rotation.angle() + PI/2
#	Projectiles.add_child(bullet)
#
#	bullet.shoot(bullet_rotation, randi_range(50,100))




func pick_new_state():
	pass
	#if (current_state == NPS_STATE.IDLE):
		#state_machine.travel("Walk")
		#current_state = NPS_STATE.WALK
	#elif(current_state == NPS_STATE.WALK):
		#state_machine.travel("Idle")
		#current_state = NPS_STATE.Idle

func _on_mouse_entered():
	sprite.material = select_material
	
	
func _on_mouse_exited():
	sprite.material = null
