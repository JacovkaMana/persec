extends Control


@export var skill_id: int = 0
@export_enum('Primary', 'Secondary') var skill_order: String
func _ready():
	connect("gui_input", _on_gui_input)
	pass # Replace with function body.
	
func _process(_delta):
	pass


func _on_gui_input(event):
	#print('button down')
	#print(event)
	#print(event.is_pressed())
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == 1:
				on_left_click(event.position)
#			if event.button_index == 2:
#				print('Right_click press')
				
		#else:
			#if event.button_index == 1:
				#print('Left_click release')	
				#reset_position()
#			if event.button_index == 2:
		#print(event)
		
func on_left_click(_cursor):
	print("skill click")
	
