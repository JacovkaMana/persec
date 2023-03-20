extends HBoxContainer

@onready var player: PlayerScript = get_tree().get_root().find_child("Player", true, false)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(player.data.stamina)
