extends Node2D

@onready var next_level_resource = load("res://Levels/game_level.tscn")
var next_scene = null

@onready var ui = load("res://Scenes/UI.tscn")
var ui_scene = null

@onready var melee = load("res://Scenes/melee_scene.tscn")
var melee_scene = null


@onready var scene_animator = $SceneAnimator


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


func setup_level(player_data, next_scene, melee_scene):
	var player_level = next_scene.find_child("Player", true, false)
	player_level.data = player_data
	player_level.player_state = Enums.EPlayerState.ROAMING
	InputManager.player = player_level
	
	
	next_scene.visible = true
	next_scene.process_mode = 0
	
	
	ui_scene.visible = true
	ui_scene.process_mode = 0
	
	for enemy in melee_scene.enemies_on_level:
		enemy.die()
	
	
	
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
	var player_melee = melee_scene.find_child("MeleePlayer", true, false)
	setup_level(player_melee.data, next_scene, melee_scene.get_child(0))
	
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
