extends Node2D


@onready var anim: AnimationPlayer = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.connect("animation_finished", _on_anim_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_anim_finished(name):
	match name:
		'start':
			self.queue_free()
