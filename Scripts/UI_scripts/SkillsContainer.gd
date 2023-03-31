extends Control

@export var lightup: Color 

var player = null
var skill_slots = null
var head_timer
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_root().find_child("Player", true, false)
	skill_slots = player.data.skills.get_skills()
	
	player.connect("skill_used", _on_skill_used)
	
	for i in get_child_count():
		if i < skill_slots.size():
			get_child(i).get_child(2).texture = skill_slots[i].icon
			get_child(i).visible = true
		else:
			get_child(i).visible = false
		#skill_slots[i]
		#skill_slots.size():
		
func _on_skill_used(skill_i: int):
	head_timer = Timer.new()
	get_child(skill_i).get_child(0).modulate = lightup

	head_timer.set_wait_time(0.2)
	head_timer.set_one_shot(true)
	head_timer.connect("timeout", reset_after_hit.bind(skill_i))  
	add_child(head_timer)
	head_timer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reset_after_hit(skill_i:int):
	get_child(skill_i).get_child(0).modulate = Color8(255,255,255,255)
	head_timer = null

	
