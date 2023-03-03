class_name EquipSlotUI
extends BaseSlotUI


signal equip_mouse_lclick(slot: BaseSlotUI)
signal equip_mouse_rclick(slot: BaseSlotUI)

@export var type:Enums.EEquipmentSlot;
# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	connect("gui_input", _on_gui_input)
	self.set_actions(["Unequip", "Delete"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == 1:
				pass
#			if event.button_index == 2:
#				print('Right_click press')
				
		else:
			if event.button_index == 1:
				on_left_release()	
				#reset_position()
			if event.button_index == 2:
				show_actions_menu()
	

func on_left_release():
	emit_signal("equip_mouse_lclick", self)
	

func show_actions_menu():
	emit_signal("equip_mouse_rclick", self)
