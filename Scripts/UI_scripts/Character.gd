extends Control

@onready var InventoryUI = get_tree().get_root().find_child("Inventory", true, false)
@onready var player = get_tree().get_root().find_child("Player", true, false)
@onready var actions_panel: Panel = get_tree().get_root().find_child("ItemActionsPanel", true, false)
@onready var PLACEMENT_DICT = {
	Enums.EItemType.WEAPON: [get_tree().get_root().find_child("AmuletPanel", true, false)],
	Enums.EItemType.ARMOR: [get_tree().get_root().find_child("MiscPanel", true, false)],
	Enums.EItemType.HELM: [get_tree().get_root().find_child("HelmPanel", true, false)],
	Enums.EItemType.BOOTS: [get_tree().get_root().find_child("BootsPanel", true, false)],
	Enums.EItemType.AMULET: [get_tree().get_root().find_child("AmuletPanel", true, false)]
}
var ItemPanel = preload('res://Inventory/ItemButton.tscn')
var node
# Called when the node enters the scene tree for the first time.
func _ready():
	#node = get_tree().get_root().get_node("GameLevel").find_child("Player")
	print(InventoryUI)
	InventoryUI.connect("update_equips", _on_update_request)
	actions_panel\
		.get_node("ItemActionsVBox")\
		.get_node("UnequipButton")\
		.connect("action_menu_click", _on_action_click)
	actions_panel\
		.get_node("ItemActionsVBox")\
		.get_node("DeleteButton")\
		.connect("action_menu_click", _on_action_click)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_viewport())
#	player.inventory.connect("added_item", _on_new_item)
#	player.inventory.connect("updated_item", _on_updated_item)
#	player.inventory.connect("removed_item", _delete_item)
	pass


func _on_update_request(placement:String, slot:BaseSlotUI):
	#мб просто обновить по слотам inventory
	var newItemPanel = ItemPanel.instantiate()
	if placement == "":
		var panel = PLACEMENT_DICT[slot.item.get_item_type()][0]
		slot.position = Vector2(0, 0)
		panel.add_child(newItemPanel)
		newItemPanel.connect("slot_mouse_lclick", _on_slot_mouse_lclick)
		newItemPanel.connect("slot_mouse_rclick", _on_slot_mouse_rclick)
		newItemPanel.connect("slot_mouse_release", _on_slot_mouse_release)
		newItemPanel.connect("slot_mouse_move_check", _on_slot_mouse_move)
	else:
		print("place in slot")


func _on_slot_mouse_rclick(slot: BaseSlotUI):
	pass
#	if (!actions_panel.visible || active_slot_rclick.item != slot.item):
#		active_slot_rclick = slot
#
#		var actions = active_slot_rclick.get_actions()
#		for action in actions_panel.get_node("ItemActionsVBox").get_children() as Array[Button]:
#			if String(action.name).split("B")[0] in actions:
#				action.visible = true
#			else:
#				action.visible = false
#
#		actions_panel.global_position = slot.global_position + Vector2(15,15)
#		actions_panel.visible = true
#	else:
#		actions_panel.visible = false


func _on_slot_mouse_lclick(slot: BaseSlotUI):
	pass
#	if (!desc_panel.visible || active_item_lclick != slot.item):
#		active_item_lclick = slot.item
#		desc_panel.find_child("NameLabel").text = slot.item.name
#		desc_panel.find_child("DescLabel").text = slot.item.description
#		desc_panel.visible = true
#	else:
#		desc_panel.visible = false
#		desc_panel.position = Vector2(-84,32)


func _on_slot_mouse_move(slot_type):
	pass
#	var mouse_pos = get_viewport().get_mouse_position()
#	if CHARACTER_PANEL_DICT[slot_type][0] < mouse_pos\
#	&& CHARACTER_PANEL_DICT[slot_type][1] > mouse_pos:
#		CHARACTER_PANEL_DICT[slot_type][2].get_child(0).visible = true
#	else:
#		CHARACTER_PANEL_DICT[slot_type][2].get_child(0).visible = false


func _on_slot_mouse_release(slot: BaseSlotUI, start_position: Vector2):
	print("mouse released")
	

func _on_action_click(action: String):
	pass
#	if active_slot_rclick != null:
#		match action:
#			"Equip":
#				if player.inventory.equip_item(active_slot_rclick.item):
#					active_slot_rclick.disconnect("slot_mouse_entered", _on_slot_mouse_entered)
#					active_slot_rclick.disconnect("slot_mouse_exited", _on_slot_mouse_exited)
#					active_slot_rclick.disconnect("slot_mouse_lclick", _on_slot_mouse_lclick)
#					active_slot_rclick.disconnect("slot_mouse_rclick", _on_slot_mouse_rclick)
#					active_slot_rclick.disconnect("slot_mouse_release", _on_slot_mouse_release)
#					active_slot_rclick.disconnect("slot_mouse_move_check", _on_slot_mouse_move)
#					emit_signal("update_equips", "", active_slot_rclick)
#					desc_panel.visible = false
#					actions_panel.visible = false
#			"Delete":
#				_delete_item(active_slot_rclick, true)
#				active_slot_rclick = null
#				desc_panel.visible = false
#				actions_panel.visible = false
