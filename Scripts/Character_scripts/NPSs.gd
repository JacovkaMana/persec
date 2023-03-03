extends Actor


  
@export var walk_radius: float = 50
var last_direction_change: float = 0
#@onready var raycast: ShapeCast2D = $RayCast
#@onready var path: Path2D = $Path2D
#@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
#@onready var path_player = $PathPlayer
@onready var vision: Area2D = $Vision
@onready var player = get_tree().get_root().find_child("Player", true, false)

var current_state : Enums.ECharacterState = Enums.ECharacterState.ROAMING
var start_pos: Vector2 = Vector2.ZERO


var select_material = preload("res://Art/Shaders/HighlightShader.tres")




func _ready():
	
	#self.connect("mouse_entered", _mouse_entered)
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)

	start_pos = self.position
	
	var timer = Timer.new()
	timer.set_wait_time(5)
	timer.set_one_shot(false)
	add_child(timer)
	timer.start()
	
	if (not self.get_collision_mask_value(7)):
		self.set_collision_mask_value(7, true)
		collision = move_and_collide(Vector2(0,0))
		print(collision)
		
	vision.connect("body_entered", _on_vision_enter) 
	vision.connect("body_exited", _on_vision_exit) 

	#move_direction = Vector2(1,0)
	
func _physics_process(_delta):
	super(_delta)
	
	match (current_state):
		Enums.ECharacterState.IDLE:
			pass
		Enums.ECharacterState.ROAMING:
			if(current_zone):
				if (current_zone.follow_position - self.global_position).length() < 2.0:
					move_speed = 0
				else:
					move_direction = (current_zone.follow_position - self.global_position).normalized()
					move_speed = 70
		Enums.ECharacterState.FIGHTING:
			pass
		Enums.ECharacterState.SEARCHING:
			pass



	
	vision.rotation = move_direction.angle() + PI
	
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
	
	
func set_zone(to : Area2D):
	current_zone = to
	print('nps at ' + str(current_zone))
	
func _on_vision_enter(who):
	if (who == player):
		label.text = "!"
		label.visible = true
		
func _on_vision_exit(who):
	if (who == player):
		label.text = "?"
		label_timer(3)
		
func label_timer(time):
	
	var _timer = Timer.new()
	label.visible = true


	_timer.set_wait_time(time)
	_timer.set_one_shot(true)
	_timer.connect("timeout", _hide_label)  
	add_child(_timer)
	_timer.start()
	
func _hide_label():
	label.visible = false
