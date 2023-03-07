class_name BootsItem
extends BaseEquipableItem

func get_item_type():
	return Enums.EItemType.BOOTS

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


	self.modifiers.append(
		Modifier.new()
	)


func is_equipable()->bool:
	return true


