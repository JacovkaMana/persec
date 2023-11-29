extends Control

@onready var animation_player : AnimationPlayer = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.queue('test')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
