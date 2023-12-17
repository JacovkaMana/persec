extends Control

@onready var anim_player : AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.


func play_anim(player_data, next_scene, melee_scene):
	anim_player.queue('transition')
