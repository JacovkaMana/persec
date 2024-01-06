extends TextureRect

var source_object = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func set_color():
	match source_object.name:
		'NPS':
			self.self_modulate = Color8(0,255,0)
		'Chest':
			self.self_modulate = Color8(255, 215, 0)
