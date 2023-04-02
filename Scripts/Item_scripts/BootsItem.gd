class_name BootsItem
extends BaseEquipableItem



func get_item_type():
	return Enums.EItemType.BOOTS
	
func get_equip_type():
	return Enums.EEquipType.BOOTS

func get_type_text()->String:
		return "Boots"

func get_slot_type():
	return [Enums.EEquipmentSlot.BOOTS]
	
	
	
func _init(_name: String = '', _description: String = '', _rarity = null):
	
	sprite = preload("res://Art/Sprites/Boots/Boots1.png")
	
	self.description = _description
	
	if (_rarity):
		self.rarity = _rarity
	else: 
		self.rarity = RandomStats.random_rarity()

	if (_name):
		self.name = _name
	else:
		self.name = 'Botz'

	item_stats["Physical Defense"] = 0
	item_stats["Magic Defense"] = 0
	item_stats["Evasion"] = 0

	generate_modifiers()


func is_equipable()->bool:
	return true


