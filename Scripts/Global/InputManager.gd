extends Node

var player = null
var UI_Global = null

@onready var SceneManager = $"../SceneManager"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(event):
	if is_instance_valid(player):
		match (player.player_state):
			Enums.EPlayerState.NONE:
				pass
			Enums.EPlayerState.ROAMING:
				ui(event)
				player_movement(event)
				use_skills(event)
				interact(event)
			Enums.EPlayerState.TALKING:
				interact(event)
			Enums.EPlayerState.RANGE:
				pass
			Enums.EPlayerState.MELEE:
				use_skills(event)



func ui(_event):
	
	if _event.is_action_pressed("character"):
		UI_Global.character_switch()
			
	if _event.is_action_pressed("inventory"):
		UI_Global.inventory_switch()
		
	if _event.is_action_pressed("interact"):
		UI_Global.dropped_switch()
		
	if _event.is_action_pressed("menu"):
		UI_Global.menu_switch()
		

func interact(_event):
	if _event.is_action_pressed("interact"):
		player.move_direction = Vector2(0, 0);
		player.interact_with_nearest()
		
func player_movement(_event):
	
	player.move_direction = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") -  Input.get_action_strength("up")
	)

func use_skills(_event):

		if _event.is_action_pressed("ability"):
			SceneManager.timestop()
		
		if _event.is_action_pressed("skill1"):
			player.use_skill_id(0)
		if _event.is_action_pressed("skill2"):
			player.use_skill_id(1)
		if _event.is_action_pressed("skill3"):
			player.use_skill_id(2)
		if _event.is_action_pressed("skill4"):
			player.use_skill_id(3)
		if _event.is_action_pressed("skill5"):
			player.use_skill_id(4)
#		if _event.is_action_pressed("skill6"):
#			player.use_skill_id(5)
#		if _event.is_action_pressed("skill7"):
#			player.use_skill_id(6)
#		if _event.is_action_pressed("skill8"):
#			player.use_skill_id(7)
