extends HBoxContainer

@onready var equip = $"../Equipment"
@onready var skill = $"../SkillStats"
# Called when the node enters the scene tree for the first time.
func _ready():
	_on_equip_selected()
	get_child(0).connect("pressed", _on_equip_selected)
	get_child(1).connect("pressed", _on_stats_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_equip_selected():
	skill.visible = false
	equip.visible = true
	
func _on_stats_selected():
	equip.visible = false
	skill.visible = true
