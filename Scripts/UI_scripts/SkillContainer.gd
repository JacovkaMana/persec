extends Control

@onready var start_position: Vector2
@onready var animated_parts = $AnimatedParts
var animated_lines = []
var rand
var last_rand
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("gui_input", _on_gui_input)
	animated_lines = animated_parts.get_children()
	for line in animated_lines:
		randomize()
		rand = randi_range(0, 10)
		if (rand != last_rand):
			line.initiate(0)
		last_rand = randi_range(0, 10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == 1:
				start_position = event.position
#			if event.button_index == 2:
#				print('Right_click press')
				
		else:
			if event.button_index == 1:
				on_left_release()	
				#reset_position()
			if event.button_index == 2:
				pass
				
	if event is InputEventMouseMotion and event.button_mask == 1:
		self.position += event.position - start_position

	
func on_left_release():
	pass
