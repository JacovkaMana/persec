extends Panel

@onready var start_position = self.position


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("gui_input", _on_gui_input)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
#				print('Right_click release')
	
	if event.button_mask == 1:
		follow_cursor(event.position)
		#print(event)
		
func on_left_click(cursor):
	print(get_viewport().get_mouse_position(), "cursor")
	print(self.position, "position")
	start_position = cursor
	

func follow_cursor(cursor):
	self.position += cursor - start_position
	
	
func reset_position():
	self.position = start_position
