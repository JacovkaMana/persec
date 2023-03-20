class_name ItemSlotUI
extends BaseSlotUI

signal slot_mouse_lclick(slot: BaseSlotUI)
signal slot_mouse_rclick(slot: BaseSlotUI)
signal slot_mouse_move_check(slot_index)

@onready var following: bool = false
@onready var start_position = self.position
@onready var area2d = $Area2D
var type:Enums.EEquipmentSlot = Enums.EEquipmentSlot.NONE;
var slot_entered: Area2D = null


func _ready()->void:
	super._ready()
	area2d.connect("area_entered", _on_area_entered)
	area2d.connect("area_exited", _on_area_exited)
	#area2d.connect("mouse_exited", _on_me)
	connect("gui_input", _on_gui_input)
	self.set_actions(["Equip", "Delete"])


func _process(_delta):
	pass


func _on_area_entered(area:Area2D)->void:
	if area.get_parent() and \
	(area.get_parent().type == self.item.get_slot_type()[0] \
	or area.get_parent().type == Enums.EEquipmentSlot.CHARACTER):
		if slot_entered:
			slot_entered.get_parent().get_parent().get_node("HoverRect").visible = false
		slot_entered = area
		slot_entered.get_parent().get_parent().get_node("HoverRect").visible = true
	
func _on_area_exited(area:Area2D)->void:
	if slot_entered and area == slot_entered:
		slot_entered.get_parent().get_parent().get_node("HoverRect").visible = false
		slot_entered = null
		


func _on_gui_input(event):
	
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
	#Возможно тут проверка на то, правильный ли тип слота
	if slot_entered:
		#player.data.
		#print(inventory)
		inventory.equip_item(self.item)
	if following:
		reset_position()
		following = false
	
	
func reset_position():
	self.position = start_position

	
func show_actions_menu():
	emit_signal("slot_mouse_rclick", self)
	
