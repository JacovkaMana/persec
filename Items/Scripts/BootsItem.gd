class_name BootsItem
extends ArmorItem

func get_item_type():
	return Enums.EItemType.BOOTS

func get_type_text()->String:
		return "Boots"

func get_slot_type():
	return [Enums.EEquipmentSlot.BOOTS]
	
func initialize(name: String = '', description: String = '', rarity = null):
	
	sprite = preload("res://Art/Sprites/Boots/Boots1.png")
	
	self.description = description
	
	if (rarity):
		self.rarity = rarity
	else: 
		self.rarity = RandomStats.random_rarity()

	if (name):
		self.name = name
	else:
		self.name = 'Botz'


	self.modifiers.append(
		Modifier.new()
	)


