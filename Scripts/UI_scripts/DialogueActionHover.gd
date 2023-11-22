extends TextureRect


@onready var DialogueControl: Control = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	#connect("gui_input", _on_gui_input)
	#connect("gui_input", _on_gui_input)
	connect("mouse_entered", _on_mouse_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_gui_input(event):
	#print('button down')
	#print(event)
	#print(event.is_pressed())
	print('mouse cathc')
	if event is InputEventMouseButton:
		pass

func _on_mouse_entered():
	DialogueControl._on_choice(
		['asd','asd','asd','asd']
	)

func gui_input(event):
	print('raw')
