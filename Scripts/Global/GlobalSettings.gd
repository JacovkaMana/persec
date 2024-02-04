extends Node

@onready var data = Settings.new()

func save_settings():
	var result = ResourceSaver.save(self.data, 'user://settings.res')
	assert(result == OK)
	print(result)

func load_settings():
	if ResourceLoader.exists('user://settings.res'):
		var object = ResourceLoader.load('user://settings.res')
		return object
	return null
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
