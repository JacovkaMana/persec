extends Control

@onready var inventory_grid: GridContainer = get_node("InventoryGrid")
@onready var desc_panel: Panel = get_node("ItemDescPanel")
@onready var player = get_tree().get_root().find_child("Player", true, false)
@onready var active_item_lclick: Item = null
@onready var active_slot_rclick: BaseSlotUI = null
@onready var actions_panel: Panel = get_tree().get_root().find_child("ItemActionsPanel", true, false)
@onready var panel_hover = false
var ItemButton = preload("res://Scenes/Inventory/ItemButton.tscn")
# !!!!! При закрытии закрывается ItemActionsPanel, если она над этой менюшкой!!!
# Called when the node enters the scene tree for the first time.

@onready var ui_settings = get_parent().get_parent()
@onready var bground = $Background
@onready var shadow = $Shadow
@onready var inventory_container = $InventoryContainer

func _ready():
#	bground.modulate = ui_settings.BackgroundColor
#	shadow.modulate = ui_settings.ShadowColor
	
	inventory_container.get_child(0).connect("pressed", update_inventory.bind([Enums.EItemType.NONE]))
	inventory_container.get_child(1).connect("pressed", update_inventory.bind([Enums.EItemType.WEAPON]))
	inventory_container.get_child(2).connect("pressed", update_inventory.bind([Enums.EItemType.ARMOR, Enums.EItemType.HELM, Enums.EItemType.BOOTS]))
	inventory_container.get_child(3).connect("pressed", update_inventory.bind([Enums.EItemType.KEY]))
	inventory_container.get_child(4).connect("pressed", update_inventory.bind([Enums.EItemType.CONSUMABLE]))
	
	#print('Player test node')
	#print(player.inventory)
	player.data.inventory.connect("added_item", _on_new_item)
	player.data.inventory.connect("updated_item", _on_updated_item)
	player.data.inventory.connect("removed_item", _delete_item)
	actions_panel\
		.get_node("ItemActionsVBox")\
		.get_node("EquipButton")\
		.connect("action_menu_click", _on_action_click)
	actions_panel\
		.get_node("ItemActionsVBox")\
		.get_node("DeleteButton")\
		.connect("action_menu_click", _on_action_click)
		
	update_inventory([Enums.EItemType.NONE]);

	# По хорошему обновление должно идти из кнопки, т.е. при открытии инвентаря по 
	# дефолту выбрана вкладка 'Все предметы' и оттуда загружаются все предметы
	# Хз верхним кнопкам отдельный нужен скрипт или как это сделать
#
#	for slot in inventory_grid.get_children() as Array[ItemSlotUI]:
#		slot.connect("slot_mouse_lclick", _on_slot_mouse_lclick)
#		slot.connect("slot_mouse_rclick", _on_slot_mouse_rclick)
#		slot.connect("slot_mouse_release", _on_slot_mouse_release)
#		slot.connect("slot_mouse_move_check", _on_slot_mouse_move)
#
#
#		if (not slot.item):
#			slot.item = Item.new()
				
	pass # Replace with function body.
	
func update_inventory(types_arr: Array)->void:
	for slot in inventory_grid.get_children() as Array[ItemSlotUI]:
		inventory_grid.remove_child(slot)
	
	for inv_item in player.data.inventory.get_inventory_items():
		var type_cond = false
		if (types_arr[0] == Enums.EItemType.NONE):
			type_cond = true
		else:
			for type in types_arr:
					if inv_item.get_item_type() == type:
						type_cond = true
					
		if (type_cond):
			var newItemButton = ItemButton.instantiate()
		
			inventory_grid.add_child(newItemButton)
			
			newItemButton.set_item(inv_item)
			newItemButton.find_child("ItemImage").texture = inv_item.sprite
			#var mater = ShaderMaterial.new()
			#mater.shader = ItemShader
			#mater.set_shader_parameter('color',RandomStats.rarity_colors[new_item.rarity])
			#newItemButton.find_child("ItemImage").material = mater
			if (inv_item.is_stackable()):
				newItemButton.find_child("ItemCount").text = str(inv_item.count)
				newItemButton.find_child("ItemCount").visible = true
			
			newItemButton.connect("slot_mouse_lclick", _on_slot_mouse_lclick)
			newItemButton.connect("slot_mouse_rclick", _on_slot_mouse_rclick)


func _on_new_item(new_item)->bool:
	#print(new_item, "NEW ITEM ADDED")
	
	var newItemButton = ItemButton.instantiate()
	
	inventory_grid.add_child(newItemButton)
	
	newItemButton.set_item(new_item)
	newItemButton.find_child("ItemImage").texture = new_item.sprite
	#var mater = ShaderMaterial.new()
	#mater.shader = ItemShader
	#mater.set_shader_parameter('color',RandomStats.rarity_colors[new_item.rarity])
	#newItemButton.find_child("ItemImage").material = mater
	if (new_item.is_stackable()):
		newItemButton.find_child("ItemCount").text = str(new_item.count)
		newItemButton.find_child("ItemCount").visible = true
		
	
	newItemButton.connect("slot_mouse_lclick", _on_slot_mouse_lclick)
	newItemButton.connect("slot_mouse_rclick", _on_slot_mouse_rclick)
	
	return true
	
func _delete_item(item, delete: bool = false)->bool:
	for slot in inventory_grid.get_children() as Array[ItemSlotUI]:
		if slot.item == item:
			inventory_grid.remove_child(slot)
			if (delete):
				player.data.inventory.remove_item(item)
			return true
	return false

func _on_updated_item(new_item)->bool:
	
	_delete_item(new_item, false)
	_on_new_item(new_item)
	return true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_slot_mouse_lclick(slot: BaseSlotUI):
	if (!desc_panel.visible || active_item_lclick != slot.item):
		active_item_lclick = slot.item
#		desc_panel.find_child("NameLabel").text = slot.item.name
#		desc_panel.find_child("DescLabel").text = slot.item.description
#		desc_panel.visible = true
		desc_panel.set_item(slot.item)
	else:
		desc_panel.remove_item()
#		desc_panel.visible = false
#		desc_panel.position = Vector2(-84,32)
		
	
func _on_action_click(action: String):
	if active_slot_rclick != null:
		match action:
			"Equip":
				if player.data.inventory.equip_item(active_slot_rclick.item):
					active_slot_rclick.disconnect("slot_mouse_lclick", _on_slot_mouse_lclick)
					active_slot_rclick.disconnect("slot_mouse_rclick", _on_slot_mouse_rclick)
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
	

