extends Button

signal menu_close_clicked(name: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", _on_mouse_clicked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_mouse_clicked():
	self.get_parent().visible = false
