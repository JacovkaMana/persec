extends Control



@onready var player: MeleePlayer = $MeleePlayer
var enemies: Array = []
var enemies_on_level: Array

@onready var enemies_container = $EnemiesContainer
@onready var player_hud = $HUD
@onready var SceneManager = self.get_tree().get_root().find_child("SceneManager", true, false)
@onready var BG: TextureRect = $Background
@onready var BG_AnimationPlayer: AnimationPlayer = $Background/AnimationPlayer

@export var starting_color: Color

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func setup(old_player, enemies):
	self.enemies_on_level = enemies
	
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
	
func get_enemy_node(id: int):
	var enemy_node = enemies_container.get_child(id)
	return enemy_node
	
func end_melee():
	SceneManager.remove_melee()
	
func play_damage(skill: Skill):
	var color = RandomStats.type_colors[skill.damage_type]
	var tween = get_tree().create_tween()
	#var starting_color = BG.material.get_shader_parameter('edge_color')
	tween.tween_method(set_shader_value, starting_color, color, 0.5)
	tween.tween_method(set_shader_value, color, starting_color, 0.5)

func set_shader_value(value):
	BG.material.set_shader_parameter("edge_color", value);
	
func check_for_melee_end():
	for enemy in enemies_container.get_children():
		if enemy.visible == true:
			return false
	end_melee()
	
