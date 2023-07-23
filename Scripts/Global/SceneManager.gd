extends Node2D

@onready var next_level_resource = load("res://Levels/game_level.tscn")
var next_scene = null

@onready var ui = load("res://Scenes/UI.tscn")
var ui_scene = null

@onready var melee = load("res://Scenes/melee_scene.tscn")
var melee_scene = null


# Called when the node enters the scene tree for the first time.
func _ready():
	
	next_scene = next_level_resource.instantiate()
	self.add_child(next_scene)
	
	ui_scene = ui.instantiate()
	self.add_child(ui_scene)
		
	#self.add_melee()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_melee(player, enemies):
	melee_scene = melee.instantiate()
	
	next_scene.visible = false
	next_scene.process_mode = 4
	ui_scene.visible = false
	ui_scene.process_mode = 4
	
	self.add_child(melee_scene)
	melee_scene.get_child(0).setup(player, enemies)
	print(player)
	print(player.get_script())
	
func remove_melee():
	melee_scene.queue_free()
	
func pause_game():
	next_scene.process_mode = 4
	
func unpause_game():
	next_scene.process_mode = 0
	
	
func save_resource(what, where):
	var result = ResourceSaver.save(what, where)
	assert(result == OK)
	print(result)
	
func load_resource(what):
	if ResourceLoader.exists(what):
		var object = ResourceLoader.load(what)
		return object
