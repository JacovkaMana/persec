class_name Inventory
extends Resource


signal moved_item_to_chest(item: Item, count: int)
signal added_item(item: Item)
signal updated_item(item: Item)
signal removed_item(item: Item, delete: bool)
signal equip_item_changed(slot_type: Enums.EEquipmentSlot, item_slot)
signal consumable_item_changed(slot_number: int, item_slot)

@export var _inventory: Array[Item]
@export var _equipment: Dictionary = {
	#weapons
	Enums.EEquipmentSlot.L_HAND: null,
	Enums.EEquipmentSlot.R_HAND: null,
	#right armor
	Enums.EEquipmentSlot.HELM: null,
	Enums.EEquipmentSlot.ARMOR: null,
	Enums.EEquipmentSlot.PANTS: null,
	Enums.EEquipmentSlot.BOOTS: null,
	#left armor
	Enums.EEquipmentSlot.AMULET: null,
	Enums.EEquipmentSlot.ACCESSORY_1: null,
	Enums.EEquipmentSlot.ACCESSORY_2: null,
	Enums.EEquipmentSlot.GLOVES: null,
}

@export var _consumable_items: Array[BaseConsumableItem] = []
var _consumable_item_limit: int = 4

var _is_initialize: bool = false


func add_item(item: Item, item_count: int = 1):

	if (item.is_stackable() and (item in _inventory)):
		_inventory[_inventory.find(item)].count += item_count
		emit_signal("updated_item", item)
		return true
	else:
		_inventory.append(item)
		emit_signal("added_item", item)
		return true	
		
	#return false
	
	
func is_initialized()->bool:
	return _is_initialize


func remove_item(item: Item, count: int = 1):
	if count == -1:
		count = _inventory[_inventory.find(item)].count
	if (item in _inventory):
		if item.is_stackable():
			if (_inventory[_inventory.find(item)].count - count <= 0):
				_inventory.pop_at(_inventory.find(item))
				emit_signal("removed_item", item, true)
			else:
				_inventory[_inventory.find(item)].count -= count
				emit_signal("updated_item", item, true)
			return true
		else:
			_inventory.pop_at(_inventory.find(item))
			emit_signal("removed_item", item, true)
			return true
	return false


func equip_item(item: Item)->bool:	
	#var item_type = item.get_item_type()
	var slot_type = item.get_slot_type()[0]
	match item.get_type_text():
		'Equipable':
			print('equip equipable')
			if item.get_equip_type() == Enums.EEquipType.WEAPON:
				if item.twohanded:
					for slot in item.get_slot_type():
						if _equipment[slot]:
							var old_item = _equipment[slot]
							_equipment[slot] = null
							add_item(old_item)		
				else:
					for slot in item.get_slot_type():
						if not _equipment[slot]:
							slot_type = slot
							break
			if slot_type not in _equipment.keys():
				return false
			
			if item.get_equip_type() == Enums.EEquipType.WEAPON:
				pass
				#item.twohanded
				
			
			
			if _equipment[slot_type]:
				var old_item = _equipment[slot_type]
				self.add_item(old_item)
				
			_equipment[slot_type] = item
			self.remove_item(item)
				
			self.emit_signal("equip_item_changed", slot_type, item)
			return true
		'Consumable':
			print('asd')
			if len(_consumable_items) == 4:
				self.add_item( _consumable_items.pop_back() )
			_consumable_items.append(item)
			self.remove_item(item, -1)
			var slot_number = _consumable_items.find(item)
			
			self.emit_signal("consumable_item_changed", slot_number, item)
			return true
	
	return true
	

func unequip_slot(slot_type: Enums.EEquipmentSlot)->bool:	
	
	if _equipment[slot_type]:
		var old_item = _equipment[slot_type]
		self.add_item(old_item)
		_equipment[slot_type] = null
		self.emit_signal("equip_item_changed", slot_type, null)
		return true
		
	else:
		return false



func get_equipments()->Dictionary:
	return _equipment


func get_equipments_slot(slot_type: Enums.EEquipmentSlot):
	return _equipment[slot_type]



func get_inventory_items()->Array: #[InventoryItemSlotInfo]:
	return _inventory


func get_inventory_items_by_type(item_type: Enums.EItemType)->Array: #[InventoryItemSlotInfo]:
	var out: Array[Item] = []
	for item in _inventory:
		if item.get_item_type() == item_type:
		#if item.get_item_info().get_item_type() == item_type:
			out.append(item)
	
	return out
	

func has_key_item(item_name: String, _item_count: int = -1) -> bool:
	for item in _inventory:
		if item.get_item_type() == Enums.EItemType.KEY:
			if item.keyitem_name == item_name:
				return true
	return false




