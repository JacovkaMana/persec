extends Node

@onready var data = Settings.new()

func save_resource(what, where):
	var result = ResourceSaver.save(self.data, 'user://player_settings.res')
	assert(result == OK)
	print(result)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
