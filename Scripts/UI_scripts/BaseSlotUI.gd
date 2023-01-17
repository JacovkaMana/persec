class_name BaseSlotUI
extends TextureButton


signal slot_mouse_entered(slot_index: BaseSlotUI)
signal slot_mouse_exited(slot_index: BaseSlotUI)

@onready var content: Control = get_node("Content")
@onready var count_label: Label = get_node("Content/CountLabel")
@onready var item_icon: TextureRect = get_node("Content/ItemTextureRect")
@onready var selector_icon: TextureRect = get_node("Content/SelectorTextureRect")
@onready var inventory: Node2D = null
@onready var item = null


var _slot_info: InventoryItemSlotInfo = null 

func _ready()->void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	inventory = get_tree().get_root().get_node("Inventory")
#	self.connect("slot_mouse_entered", self, "on_slot_mouse_entered")

#	test item
	#str(randi_range(0,100)
	
func set_item(slot_item: Item)->bool:
	item = slot_item
	return true


#func start_drag():
#	item_icon.modulate = Color(0.0, 0.0, 0.0, 0.5)
#	set_select(true)


#func end_drag():
#	item_icon.modulate = Color(1.0, 1.0, 1.0, 1.0)
#	set_select(false)


func set_select(value: bool):
	selector_icon.visible = value


func update_ui(slot: InventoryItemSlotInfo)->void:
	if (slot == null):
		_slot_info = null
		content.visible = false
		selector_icon.visible = false
		return
	
	_slot_info = slot
	content.visible = true
	
	var item_info: Item = _slot_info.get_item_info()
	item_icon.texture = item_info.icon
	
	if (item_info.is_stackable()):
		count_label.visible = true
		count_label.text = str(_slot_info.count)
	else:
		count_label.visible = false


func get_item_slot_info()->InventoryItemSlotInfo:
	return _slot_info


func is_empty()->bool:
	return _slot_info == null


func _on_mouse_entered():
	emit_signal("slot_mouse_entered", self)


func _on_mouse_exited():
	emit_signal("slot_mouse_exited", self)

#func _on_gui_input(event):
	#print('button down')
	#print(event)
	#print(event.is_pressed())
	
#	if event is InputEventMouseButton:
#		if event.button_index == 1 and event.is_pressed():
#			print('Left_click')
#			emit_signal('left_clicked')
#		elif event.button_index == 1 and not event.is_pressed():
#			print('Not Left Click')

	
