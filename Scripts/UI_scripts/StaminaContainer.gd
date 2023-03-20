extends HBoxContainer

@onready var player: PlayerScript = get_tree().get_root().find_child("Player", true, false)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(player.data.stamina)
	for i in range(self.get_child_count()):
		if (i + 1) <= player.data.max_stamina:
			self.get_child(i).self_modulate = Color(1,1,1,  min(player.data.stamina, i + 1) / (i + 1))
		else:
			self.get_child(i).visible = false
