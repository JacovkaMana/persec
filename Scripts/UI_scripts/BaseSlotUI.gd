class_name BaseSlotUI
extends TextureButton


signal slot_mouse_entered(slot_index: BaseSlotUI)
signal slot_mouse_exited(slot_index: BaseSlotUI)

@export var item: Item = null

@onready var content: Control = $Content
@onready var item_icon: TextureRect = null
@onready var selector_icon: TextureRect = null
@onready var inventory = null
var actions = []


var _slot_info: InventoryItemSlotInfo = null 

func _ready()->void:
	inventory = get_tree().get_root().find_child("Inventory", true, false)
#	self.connect("slot_mouse_entered", self, "on_slot_mouse_entered")

	
func set_item(slot_item: Item)->bool:
	item = slot_item
	self.self_modulate = RandomStats.rarity_colors[item.rarity]
	return true
	
	
func set_actions(new_actions: Array):
	actions = new_actions


func get_actions():
	return actions


#func start_drag():
#	item_icon.modulate = Color(0.0, 0.0, 0.0, 0.5)
#	set_select(true)


#func end_drag():
#	item_icon.modulate = Color(1.0, 1.0, 1.0, 1.0)
#	set_select(false)


#func set_select(value: bool):
#	selector_icon.visible = value


#func update_ui(slot: InventoryItemSlotInfo)->void:
#	if (slot == null):
#		_slot_info = null
#		content.visible = false
#		selector_icon.visible = false
#		return
#
#	_slot_info = slot
#	content.visible = true
#
#	var item_info: Item = _slot_info.get_item_info()
#	item_icon.texture = item_info.icon
#
#	if (item_info.is_stackable()):
#		count_label.visible = true
#		count_label.text = str(_slot_info.count)
#	else:
#		count_label.visible = false


func get_item_slot_info()->InventoryItemSlotInfo:
	return _slot_info


func is_empty()->bool:
	return _slot_info == null
