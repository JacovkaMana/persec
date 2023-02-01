class_name ArmorItem
extends BaseUndurableItem

@export var level: int = 1

@export_category(Defence)
@export var physical_defence: float
@export var magic_defence: float
@export var fire_defence: float
@export var ice_defence: float

@export var modifiers: Array[Modifier] = []

func get_type_text()->String:
		return "Armor"

func initialize(name: String = '', description: String = '', rarity = null):
	
	sprite = preload("res://Art/Sprites/Armor/Armor1.png")
	
	self.description = description
	
	if (rarity):
		self.rarity = rarity
	else: 
		self.rarity = RandomStats.random_rarity()

	if (name):
		self.name = name
	else:
		self.name = 'Arrmor'


	self.modifiers.append(
		Modifier.new()
	)

func get_item_type():
	return Enums.EItemType.ARMOR

func get_slot_type():
	return [Enums.EEquipmentSlot.ARMOR]


