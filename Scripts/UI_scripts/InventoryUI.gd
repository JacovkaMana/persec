extends Control


@onready var CHARACTER_PANEL_DICT = {
	Enums.EItemType.ITEM: [Vector2(23, 68), Vector2(41, 88), get_tree().get_root().find_child("MiscPanel", true, false)],
	Enums.EItemType.WEAPON: [Vector2(33, 100), Vector2(51, 120), get_tree().get_root().find_child("AmuletPanel", true, false)],
	Enums.EItemType.ARMOR: [Vector2(23, 68), Vector2(41, 88), get_tree().get_root().find_child("MiscPanel", true, false)],
	Enums.EItemType.HELM: [Vector2(23, 68), Vector2(41, 88), get_tree().get_root().find_child("HelmPanel", true, false)],
	Enums.EItemType.BOOTS: [Vector2(23, 68), Vector2(41, 88), get_tree().get_root().find_child("BootsPanel", true, false)],
	Enums.EItemType.AMULET: [Vector2(23, 68), Vector2(41, 88), get_tree().get_root().find_child("AmuletPanel", true, false)],
	Enums.EItemType.CONSUMABLE: [Vector2(23, 68), Vector2(41, 88), get_tree().get_root().find_child("MiscPanel", true, false)]
}
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
func _ready():
	
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

	# По хорошему обновление должно идти из кнопки, т.е. при открытии инвентаря по 
	# дефолту выбрана вкладка 'Все предметы' и оттуда загружаются все предметы
	# Хз верхним кнопкам отдельный нужен скрипт или как это сделать
	
	for slot in inventory_grid.get_children() as Array[ItemSlotUI]:
		slot.connect("slot_mouse_lclick", _on_slot_mouse_lclick)
		slot.connect("slot_mouse_rclick", _on_slot_mouse_rclick)
		slot.connect("slot_mouse_release", _on_slot_mouse_release)
		slot.connect("slot_mouse_move_check", _on_slot_mouse_move)
		
		
		if (not slot.item):
			slot.item = Item.new()
				
	pass # Replace with function body.


func _on_new_item(new_item)->bool:
	#print(new_item)
	
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
	newItemButton.connect("slot_mouse_release", _on_slot_mouse_release)
	newItemButton.connect("slot_mouse_move_check", _on_slot_mouse_move)
	
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
func _process(delta):
	pass
	
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
					active_slot_rclick.disconnect("slot_mouse_release", _on_slot_mouse_release)
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


func _on_slot_mouse_move(slot_type):
	var mouse_pos = get_viewport().get_mouse_position()
	if CHARACTER_PANEL_DICT[slot_type][0] < mouse_pos\
	&& CHARACTER_PANEL_DICT[slot_type][1] > mouse_pos:
		CHARACTER_PANEL_DICT[slot_type][2].get_child(0).visible = true
		panel_hover = true
	else:
		CHARACTER_PANEL_DICT[slot_type][2].get_child(0).visible = false
		panel_hover = false


func _on_slot_mouse_release(slot: BaseSlotUI, start_position: Vector2):
	if panel_hover:
		print("released on panel, equip needed")
	else:
		slot.position = start_position

