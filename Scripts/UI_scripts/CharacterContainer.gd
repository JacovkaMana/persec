extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_equip_selected()
	get_child(0).connect("pressed", _on_equip_selected)
	get_child(1).connect("pressed", _on_stats_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_equip_selected():
	get_parent().get_child(4).visible = false
	get_parent().get_child(3).visible = true
	
func _on_stats_selected():
	get_parent().get_child(3).visible = false
	get_parent().get_child(4).visible = true
