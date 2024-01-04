extends Node2D


@onready var main_camera = $MainCamera


@onready var next_level_resource = load("res://Levels/Dungeon.tscn")
var next_scene = null

@onready var ui = load("res://Scenes/UI.tscn")
var ui_scene = null

@onready var melee = load("res://Scenes/melee_scene.tscn")
var melee_scene = null


@onready var scene_animator: AnimationPlayer = $SceneTransitionLayer/AnimationPlayer

@onready var vfx_layer = null

var player = null
var enemies = null

# Called when the node enters the scene tree for the first time.
func _ready():
	#scene_animator.queue("RESET")
	scene_animator.connect("animation_finished", _on_animation_finished)
	
	next_scene = next_level_resource.instantiate()
	self.add_child(next_scene)
	
	player = next_scene.find_child("Player", true, false)
	
	main_camera.global_position = player.global_position
	player.find_child('RemoteTransform2D').remote_path = main_camera.get_path()
	print(player.find_child('RemoteTransform2D').remote_path)

	#main_camera.global_position = player.global_position

	
	vfx_layer = next_scene.find_child("VFX", true, false)
	
	ui_scene = ui.instantiate()
	self.add_child(ui_scene)
		
	#self.add_melee()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#main_camera.global_position = player.global_position
	#print(main_camera.global_position)
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
	
	scene_animator.queue("into_battle")
	self.player = player
	player.freeze = true
	self.enemies = enemies
	for enemy in enemies:
		enemy.freeze = true
	
func _on_animation_finished(_anim):
	match _anim:
		"into_battle":
				
			melee_scene = melee.instantiate()

			next_scene.visible = false
			next_scene.process_mode = 4
			ui_scene.visible = false
			ui_scene.process_mode = 4

			self.add_child(melee_scene)
			melee_scene.get_child(0).setup(player, enemies)
			print(player)
			print(player.get_script())
			
			scene_animator.queue("finish_battleanim")
		
		"out_of_battle":
			var player_melee = melee_scene.find_child("MeleePlayer", true, false)
			setup_level(player_melee.data, next_scene, melee_scene.get_child(0))
			melee_scene.queue_free()
			
			scene_animator.queue("finish_battleanim")
			
		"finish_battleanim":
			scene_animator.queue("RESET")
			
			player.freeze = false
			
	
func remove_melee():
	scene_animator.queue("out_of_battle")
	
	
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



func do_vfx(where, which, color = NAN):
	var obj = load("res://PreRendered/VFX/Impact.tscn")
	var new_obj = obj.instantiate()
	
	if color:
		new_obj.get_child(0).modulate = color
	

	vfx_layer.add_child(new_obj)
	
	
	new_obj.global_position = where
	
	
	new_obj.get_child(1).queue('start')
