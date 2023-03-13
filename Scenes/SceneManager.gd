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
		
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_melee():
	melee_scene = melee.instantiate()
	
	next_scene.process_mode = 4
	
	self.add_child(melee_scene)
	
func remove_melee():
	melee_scene.queue_free()
