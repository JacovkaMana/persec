extends Control

@onready var inventory_grid: GridContainer = $InventoryGrid
@onready var player = get_tree().get_root().find_child("Player", true, false)
@onready var desc_panel: Panel = $ItemDescPanel
@onready var actions_panel: Panel = get_tree().get_root().find_child("ItemActionsPanel", true, false)


var active_item_lclick: Item = null
var active_slot_rclick: BaseSlotUI = null
var panel_hover = false
var ItemButton = preload("res://Scenes/Inventory/ItemButton.tscn")

var _item_inventory = null
# !!!!! При закрытии закрывается ItemActionsPanel, если она над этой менюшкой!!!
# Called when the node enters the scene tree for the first time.
func _ready():
	
	player.connect("dropped_inventory_opened", _on_new_inventory)

	
	
func update_inventory()->void:
	for child in inventory_grid.get_children():
		child.queue_free()
	for inv_item in _item_inventory:
		var newItemButton = ItemButton.instantiate()
		
		inventory_grid.add_child(newItemButton)
		
		newItemButton.set_item(inv_item)
		newItemButton.find_child("ItemImage").texture = inv_item.sprite

		if (inv_item.is_stackable()):
			newItemButton.find_child("ItemCount").text = str(inv_item.count)
			newItemButton.find_child("ItemCount").visible = true
		
		newItemButton.connect("slot_mouse_lclick", _on_slot_mouse_lclick)
		newItemButton.connect("slot_mouse_rclick", _on_slot_mouse_rclick)
		newItemButton.connect("slot_mouse_move_check", _on_slot_mouse_move)


func _on_new_item(new_item)->bool:
	print(new_item, "NEW ITEM ADDED")
	
	var newItemButton = ItemButton.instantiate()
	
	inventory_grid.add_child(newItemButton)
	
	newItemButton.set_item(new_item)
	newItemButton.find_child("ItemImage").texture = new_item.sprite

	if (new_item.is_stackable()):
		newItemButton.find_child("ItemCount").text = str(new_item.count)
		newItemButton.find_child("ItemCount").visible = true
		
	newItemButton.connect("slot_mouse_lclick", _on_slot_mouse_lclick)
	newItemButton.connect("slot_mouse_rclick", _on_slot_mouse_rclick)
	newItemButton.connect("slot_mouse_move_check", _on_slot_mouse_move)
	
	return true

		

	
func _delete_item(item, _delete: bool = false)->bool:
	for slot in inventory_grid.get_children() as Array[ItemSlotUI]:
		if slot.item == item:
			inventory_grid.remove_child(slot)
			return true
	return false

	
# Called every frame. 'delta' is the elapsed time since the previous frame.

	
func _on_slot_mouse_lclick(slot: BaseSlotUI):
	if (!desc_panel.visible || active_item_lclick != slot.item):
		active_item_lclick = slot.item
		desc_panel.find_child("NameLabel").text = slot.item.name
		desc_panel.find_child("DescLabel").text = slot.item.description
		desc_panel.visible = true
	else:
		desc_panel.visible = false
		desc_panel.position = Vector2(-84,32)
		
	
func _on_action_click(action: String):
	if active_slot_rclick != null:
		match action:
			"Equip":
				if player.data.inventory.equip_item(active_slot_rclick.item):
					active_slot_rclick.disconnect("slot_mouse_lclick", _on_slot_mouse_lclick)
					active_slot_rclick.disconnect("slot_mouse_rclick", _on_slot_mouse_rclick)
					active_slot_rclick.disconnect("slot_mouse_move_check", _on_slot_mouse_move)
					desc_panel.visible = false
					actions_panel.visible = false
			"Delete":
				_delete_item(active_slot_rclick.item, true)
				active_slot_rclick = null
				desc_panel.visible = false
				actions_panel.visible = false
		
func _on_slot_mouse_rclick(slot: BaseSlotUI):
	if (!actions_panel.visible || active_slot_rclick.item != slot.item):
		active_slot_rclick = slot
		
		var actions = active_slot_rclick.get_actions()
		for action in actions_panel.get_node("ItemActionsVBox").get_children() as Array[Button]:
			if String(action.name).split("B")[0] in actions:
				action.visible = true
			else:
				action.visible = false
				
		actions_panel.global_position = slot.global_position + Vector2(15,15)
		actions_panel.visible = true
	else:
		actions_panel.visible = false


func _on_slot_mouse_move(_slot_type):
	pass

func _on_new_inventory(_inv):
	self.visible = true
	_item_inventory = _inv
	update_inventory()
