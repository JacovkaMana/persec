class_name Inventory
extends Resource


signal moved_item_to_chest(item: Item, count: int)
signal added_item(item: Item)
signal updated_item(item: Item)
signal removed_item(slot: InventoryItemSlotInfo, item: Item, removed_count: int)
signal equip_item_changed(slot_type: Enums.EEquipmentSlot, 
		from_item_slot: InventoryItemSlotInfo, to_item_slot: InventoryItemSlotInfo)

var _inventory: Array[Item]
var _equipment: Dictionary = {
	Enums.EEquipmentSlot.L_HAND: null,
	Enums.EEquipmentSlot.R_HAND: null,
	Enums.EEquipmentSlot.HELM: null,
	Enums.EEquipmentSlot.ARMOR: null,
	Enums.EEquipmentSlot.BOOTS: null,
	Enums.EEquipmentSlot.AMULET: null,
	Enums.EEquipmentSlot.CONSUMABLE_1: null,
	Enums.EEquipmentSlot.CONSUMABLE_2: null,
	Enums.EEquipmentSlot.CONSUMABLE_3: null,
	Enums.EEquipmentSlot.CONSUMABLE_4: null,
	Enums.EEquipmentSlot.CONSUMABLE_5: null,
	Enums.EEquipmentSlot.CONSUMABLE_6: null,
}

var _stats = {
	Enums.EStat.STRENGTH: null,
	Enums.EStat.DEXTERITY: null,
	Enums.EStat.CONSTITUTION: null,
	Enums.EStat.INTELLIGENCE: null,
	Enums.EStat.PERCEPTION: null,	
}

var _is_initialize: bool = false


func add_item(item: Item, count: int = 1)->InventoryItemSlotInfo:

	if (item.is_stackable() and item in _inventory):
		_inventory[_inventory.find(item)].count += 1
		emit_signal("updated_item", item)
	else:
		_inventory.append(item)
		emit_signal("added_item", item)
	
	
	return null
	

func is_initialized()->bool:
	return _is_initialize

func remove_item(item: Item, count: int)->bool:
	
	if (item in _inventory):
		_inventory.pop_at(_inventory.find(item))
		return true

	return false



func equip_item(item: Item)->bool:	
	var item_type = item.get_item_type()
	var slot_type = item.get_slot_type()[0]
	print(slot_type)
	
	if slot_type not in _equipment.keys():
		return false
	
	if _equipment[slot_type]:
		var old_item = _equipment[slot_type]
		add_item(old_item, 1)
		
	_equipment[slot_type] = item
		
	emit_signal("equip_item_changed", slot_type, item)
	return true

func unequip_slot(slot_type: Enums.EEquipmentSlot)->bool:	
	
	if _equipment[slot_type]:
		var old_item = _equipment[slot_type]
		add_item(old_item)
		_equipment[slot_type] = null
		emit_signal("equip_item_changed", slot_type, null)
		return true
		
	else:
		return false




func get_equipments()->Dictionary:
	return _equipment


func get_equippments_slot(slot_type: Enums.EEquipmentSlot)->Dictionary:
	return _equipment[slot_type]



func get_inventory_items(item_type: Enums.EItemType)->Array: #[InventoryItemSlotInfo]:
	return _inventory


func get_inventory_items_by_type(item_type: Enums.EItemType)->Array: #[InventoryItemSlotInfo]:
	var out: Array[Item]
	for item in _inventory:
		if item.get_item_type() == item_type:
		#if item.get_item_info().get_item_type() == item_type:
			out.append(item)
	
	return out
	





