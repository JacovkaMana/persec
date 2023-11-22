extends Control

@export var lightup: Color 

var current_order = 'Primary'
var player = null
var consumable_items = null
var head_timer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	player = get_tree().get_root().find_child("Player", true, false)
	consumable_items = player.data.inventory._consumable_items

	player.data.inventory.connect("consumable_item_changed", _on_item_changed)

	#self.reload_textures(skill_slots)
	
		#skill_slots[i]
		#skill_slots.size():




#func reload_textures(skills):
#	for skill_button in self.get_children():
#		var i = skill_button.skill_id
#		if i < skills.size():
#			skill_button.get_child(1).get_child(0).texture = skills[i].icon
#			skill_button.visible = true
#		else:
#			skill_button.visible = true
#			skill_button.modulate.a = 0.5
#
#		if skill_button.skill_order == self.current_order:
#			skill_button.modulate.a = 1
#		else:
#			skill_button.modulate.a = 0.5
	
func _on_item_changed(number, item):
	print(number, item)

	self.get_child(number).get_child(1).get_child(0).texture = item.sprite
	
	if item.is_stackable():
		self.get_child(number).get_child(2).text = str(item.count)
		self.get_child(number).get_child(2).visible = true
	else:
		self.get_child(number).get_child(2).visible = false
#func _on_skill_used(skill_i: int):
#	var skill_button = get_child(self.get_child_count() - skill_i - 1)
#	if skill_button.skill_order != self.current_order:
#		swap_orders(skill_button.skill_order)
#
#	head_timer = Timer.new()
#	skill_button.get_child(0).modulate = lightup
#
#	head_timer.set_wait_time(0.2)
#	head_timer.set_one_shot(true)
#	head_timer.connect("timeout", reset_after_hit.bind(skill_i))  
#	self.get_parent().add_child(head_timer)
#	head_timer.start()
#
#func swap_orders(to):
#
#	self.current_order = to
#	for skill_button in self.get_children():
#		var tween = skill_button.get_child(2)
#		if tween:
#			tween.kill()
#		tween = skill_button.create_tween()
#		var crds = skill_button.position
#		if skill_button.skill_order == self.current_order:
#			skill_button.z_index = 1
#			skill_button.modulate.a = 1
#			tween.tween_property(skill_button, "position", Vector2(crds.x, crds.y + 5), 0.15).set_trans(Tween.TRANS_SINE)
#		else:
#			skill_button.z_index = 0
#			skill_button.modulate.a = 0.5
#			tween.tween_property(skill_button, "position", Vector2(crds.x, crds.y - 5), 0.15).set_trans(Tween.TRANS_SINE)
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#
#func reset_after_hit(skill_i:int):
#	get_child(self.get_child_count() - skill_i - 1).get_child(0).modulate = Color8(255,255,255,255)
#	head_timer = null
#
#
