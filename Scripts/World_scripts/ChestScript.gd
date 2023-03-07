extends StaticBody2D

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
var starting_material
@export var chest_inventory: Array[Item] = []
@onready var player = get_tree().get_root().find_child("Player", true, false)
# Called when the node enters the scene tree for the first time.
func _ready():
	#var idle = anim.get_animation('torch_loop')
	#idle.set_loop(true)
	anim.play('chest_closed')
	starting_material = sprite.material
	sprite.material = null

	#self.connect("mouse_entered", _mouse_entered)
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	self.connect("input_event", _on_input)
	
	#print('connected')
	#print(get_collision_layer_value(1))
	#print(self.input_pickable)
	#print(self.get_signal_list())
	#print(self.get_signal_connection_list('mouse_entered'))

func _on_input(_viewport, event, _idx):
	#print('button down')
	#print(event)
	#print(event.is_pressed())
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == 1:
				pass
#			if event.button_index == 2:
#				print('Right_click press')
				
		else:
			#if event.button_index == 1:
				#print('Left_click release')	
				#reset_position()
			if event.button_index == 2:
				#print('Right_click release on chest')
				#print((self.global_position - player.global_position).length())
				if (self.global_position - player.global_position).length() < 80.0:
					player.emit_signal("dropped_inventory_opened", chest_inventory)
					anim.play('chest_opened')

func _on_mouse_entered():
	#anim.play('chest_opened')
	sprite.material = starting_material
	
	
func _on_mouse_exited():
	#anim.play('chest_closed')
	sprite.material = null
	
	

