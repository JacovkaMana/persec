extends AnimationPlayer

@onready var Menu_UI = $"../FullScreenMenu"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("finished", _on_animation_finished)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_animation_finished():
	print("!@#@#")
	if Menu_UI.animation_start:
		Menu_UI.get_child(0).visible = true
	else:
		Menu_UI.visible = false
