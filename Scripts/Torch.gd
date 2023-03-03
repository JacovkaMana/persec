extends Node2D


@onready var anim: AnimationPlayer = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	#var idle = anim.get_animation('torch_loop')
	#idle.set_loop(true)
	anim.speed_scale =  (randi() % 11) / 10 + 0.5 
	anim.play('torch_loop')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
