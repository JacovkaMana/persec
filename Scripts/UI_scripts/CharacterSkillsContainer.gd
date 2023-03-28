extends HBoxContainer

var player = null
var skill_slots = null
var head_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().find_child("Player", true, false)
	skill_slots = player.data.skills.get_skills()
	
	for i in skill_slots.size():
		get_child(i).get_child(0).texture = skill_slots[i].icon
		get_child(i).connect("pressed", _on_skill_selected.bind(skill_slots[i].description))
		get_child(i).visible = true
		#skill_slots[i]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _on_skill_selected(skill_desc: String):
	get_parent().get_child(1).text = skill_desc
