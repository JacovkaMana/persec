extends Control

@onready var player = get_tree().get_root().find_child("Player", true, false)
@onready var actions_panel: Panel = get_tree().get_root().find_child("ItemActionsPanel", true, false)
@onready var desc_panel: Panel = get_node("ItemDescPanel")
@onready var PLACEMENT_DICT: Dictionary = {
	Enums.EEquipmentSlot.L_HAND: $LHandPanel,
	Enums.EEquipmentSlot.R_HAND: $RHandPanel,
	Enums.EEquipmentSlot.HELM: $RightCharacterVBox/HelmPanel,
	Enums.EEquipmentSlot.ARMOR: $RightCharacterVBox/TorsoPanel,
	Enums.EEquipmentSlot.GLOVES: $RightCharacterVBox/PantsPanel,
	Enums.EEquipmentSlot.BOOTS: $RightCharacterVBox/BootsPanel,
	Enums.EEquipmentSlot.AMULET: $LeftCharacterVBox/AmuletPanel,
	Enums.EEquipmentSlot.ACCESSORY_1: $LeftCharacterVBox/RingPanel1,
	Enums.EEquipmentSlot.ACCESSORY_2: $LeftCharacterVBox/RingPanel2,
}
var EquipButton = preload("res://Scenes/Inventory/EquipButton.tscn")
var active_slot_rclick: BaseSlotUI = null
var active_item_lclick: Item = null


@onready var stat_label_dict: Dictionary = {
	'Damage': $CurrentStats/Damage,
	'CritCh': $CurrentStats/CritCh,
	'CritDmg': $CurrentStats/CritDmg,
	'Health': $CurrentStats/Health,
	'Defense': $CurrentStats/Defense,
	'Evasion': $CurrentStats/Evasion,
}


@onready var ui_settings = get_parent().get_parent().get_parent()
@onready var bground = $"../Background"
@onready var shadow = $"../Shadow"

@onready var stats_container = $"../SkillStats/CharacterStats/StatsContainer"

func _ready():
	#print(ui_settings.BackgroundColor)
	#bground.modulate = ui_settings.BackgroundColor
	#shadow.modulate = ui_settings.ShadowColor
	player.data.connect("stats_changed", _on_stats_changed)
	player.data.inventory.connect("equip_item_changed", _on_update_request)
	_on_update_request(Enums.EEquipmentSlot.NONE, null)
	actions_panel\
		.get_node("ItemActionsVBox")\
		.get_node("UnequipButton")\
		.connect("action_menu_click", _on_action_click)
	actions_panel\
		.get_node("ItemActionsVBox")\
		.get_node("DeleteButton")\
		.connect("action_menu_click", _on_action_click)
		
	for panel in PLACEMENT_DICT.values():
		panel.get_child(1).connect("equip_mouse_lclick", _on_equip_mouse_lclick)
		panel.get_child(1).connect("equip_mouse_rclick", _on_equip_mouse_rclick)
	
	
	player.data.recalculate_stats()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print(get_viewport())
#	player.inventory.connect("added_item", _on_new_item)
#	player.inventory.connect("updated_item", _on_updated_item)
#	player.inventory.connect("removed_item", _delete_item)
	pass


#func _delete_item(item, delete: bool = false)->bool:
#	for slot in inventory_grid.get_children() as Array[ItemSlotUI]:
#		if slot.item == item:
#			inventory_grid.remove_child(slot)
#			if (delete):
#				player.inventory.remove_item(item)
#			return true
#	return false
func _on_stats_changed(_stats):
	stat_label_dict['Damage'].text = str(player.data.calculate_damage_range())
	stat_label_dict['CritCh'].text = str(player.data.calculate_crit_chance())
	stat_label_dict['CritDmg'].text = str(player.data.calculate_crit_damage())
	stat_label_dict['Health'].text = str(player.data.calculate_hp())
	stat_label_dict['Defense'].text = str(player.data.calculate_defense())
	stat_label_dict['Evasion'].text = str(player.data.calculate_evasion())
	
	
	stats_container.reload()
	

func _on_update_request(_slot_type: Enums.EEquipmentSlot, _item_slot):
	var equipments = player.data.inventory.get_equipments()
	for equipment in equipments:
		if equipment in PLACEMENT_DICT:
			var panel_button = PLACEMENT_DICT[equipment].get_child(1)
			if equipments[equipment]:
				panel_button.get_node("Content").get_node("ItemImage").texture = equipments[equipment].sprite
				panel_button.set_item(equipments[equipment])
				#panel_button.slot_type = equipment
				panel_button.visible = true
			else:
				panel_button.item = null
				panel_button.visible = false
					

func _on_equip_mouse_rclick(slot: BaseSlotUI):
	if not (active_slot_rclick):
		pass
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


func _on_equip_mouse_lclick(slot: BaseSlotUI):
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
	pass
	if active_slot_rclick != null:
		match action:
			"Unequip":
				if player.data.inventory.unequip_slot(active_slot_rclick.type):
					desc_panel.visible = false
					actions_panel.visible = false
#			"Delete":
#				_delete_item(active_slot_rclick, true)
#				active_slot_rclick = null
#				desc_panel.visible = false
#				actions_panel.visible = false
