extends Button

signal action_menu_click(name: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", _on_mouse_clicked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_mouse_clicked():
	emit_signal("action_menu_click", String(self.name).split("B")[0])
