class_name ArmorItem
extends BaseUndurableItem

@export var level: int = 1

@export var physical_defence: float
@export var magic_defence: float
@export var fire_defence: float
@export var ice_defence: float

@export var modifiers: Array[Modifier] = []

func get_type_text()->String:
		return "Armor"

func initialize(_name: String = '', _description: String = '', _rarity = null):
	
	sprite = preload("res://Art/Sprites/Armor/Armor1.png")
	
	self.description = _description
	
	if (_rarity):
		self.rarity = _rarity
	else: 
		self.rarity = RandomStats.random_rarity()

	if (_name):
		self.name = _name
	else:
		self.name = 'Arrmor'


	self.modifiers.append(
		Modifier.new()
	)

func get_item_type():
	return Enums.EItemType.ARMOR

func get_slot_type():
	return [Enums.EEquipmentSlot.ARMOR]

func is_equipable()->bool:
	return true

