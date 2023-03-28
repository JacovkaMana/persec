extends VBoxContainer

@onready var player_data = get_tree().get_root().find_child("Player", true, false).data

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(6):
		#print(player_data.stats)
		get_child(i).get_child(1).text = str(player_data.stats[i+1])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
