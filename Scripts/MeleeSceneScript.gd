extends Control



@onready var player: MeleePlayer = $MeleePlayer
var enemies: Array = []

@onready var enemies_container = $EnemiesContainer
@onready var player_hud = $HUD
@onready var SceneManager = self.get_tree().get_root().find_child("SceneManager", true, false)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func setup(old_player, enemies):
	#self.enemies = enemies
	
	var player_data = SceneManager.load_resource('user://player_data.res')
	self.player.data = old_player.data
	self.player.instantiated = true
	player_hud.player = self.player
	
	var enemy_count = 0 
	for enemy in enemies:		
		var enemy_node = enemies_container.get_child(enemy_count).find_child("EnemyHUD", true, false)
		enemies_container.get_child(enemy_count).data = enemy.data
		enemies_container.get_child(enemy_count).instantiated = true
		enemy_count += 1
		
	while enemy_count < enemies_container.get_children().size():
		enemies_container.get_child(enemy_count).visible = false
		enemy_count += 1
	
