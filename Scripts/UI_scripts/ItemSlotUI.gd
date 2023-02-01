class_name ItemSlotUI
extends BaseSlotUI

signal slot_mouse_lclick(slot_index: BaseSlotUI)
signal slot_mouse_rclick(slot_index: BaseSlotUI)
signal slot_mouse_release(slot_index: BaseSlotUI, start_position: Vector2)
signal slot_mouse_move_check(slot_index)

@onready var equipped_icon: TextureRect = get_node("Content/IsEquippedTextureRect")
@onready var following: bool = false
@onready var start_position = self.position
var actions = ["Equip", "Delete"]

func _ready()->void:
	connect("gui_input", _on_gui_input)
	super._ready()


#func _process(delta):
#	if (following):
#		follow_cursor()


func set_actions(new_actions: Array):
	actions = new_actions


func get_actions():
	return actions


func _on_gui_input(event):
	#print('button down')
	#print(event)
	#print(event.is_pressed())
	#print(event)
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == 1:
				on_left_click()
#			if event.button_index == 2:
#				print('Right_click press')
				
		else:
			if event.button_index == 1:
				on_left_release()	
				#reset_position()
			if event.button_index == 2:
				show_actions_menu()
	
	if event is InputEventMouseMotion and event.button_mask == 1:
		follow_cursor(event.position)
		
		
func on_left_click():
	start_position = self.position
	emit_signal("slot_mouse_lclick", self)


func follow_cursor(cursor):
	following = true
	self.position += cursor - Vector2(11,11)
	
	#var abc = self.item.get_item_type()
	#Enums.EItemType.WEAPON == abc
	emit_signal("slot_mouse_move_check", self.item.get_item_type())
	#видимо сигнал вешать, потом проверять куда попали
	
	
func on_left_release():
	if following:
		emit_signal("slot_mouse_release", self, start_position)
		following = false
	
	
func reset_position():
	self.position = start_position

	
func show_actions_menu():
	emit_signal("slot_mouse_rclick", self)
	
