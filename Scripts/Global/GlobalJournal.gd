extends Node

@onready var data = Journal.new()

func save_journal():
	var result = ResourceSaver.save(self.data, 'user://journal.res')
	assert(result == OK)
	print(result)

func load_journal():
	if ResourceLoader.exists('user://journal.res'):
		var object = ResourceLoader.load('user://journal.res')
		return object
	return null



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
