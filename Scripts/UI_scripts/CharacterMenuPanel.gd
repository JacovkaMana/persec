extends Panel

@export var type:Enums.EEquipmentSlot;
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("gui_input", _on_gui_input)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	print("entered character slot")
	
	
func _on_gui_input(event):
	pass
	#print("gui input")
