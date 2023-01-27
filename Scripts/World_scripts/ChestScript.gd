extends StaticBody2D

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
var starting_material
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
	
	#print('connected')
	#print(get_collision_layer_value(1))
	#print(self.input_pickable)
	#print(self.get_signal_list())
	#print(self.get_signal_connection_list('mouse_entered'))

func _on_mouse_entered():
	#anim.play('chest_opened')
	sprite.material = starting_material
	
	
func _on_mouse_exited():
	#anim.play('chest_closed')
	sprite.material = null
	
	

