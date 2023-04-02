class_name GlovesItem
extends BaseEquipableItem


@export var physical_defence: float
@export var magic_defence: float
@export var fire_defence: float
@export var ice_defence: float


func get_type_text()->String:
		return "Armor"

func _init(_name: String = '', _description: String = '', _rarity = null):
	
	sprite = preload("res://Art/Sprites/Armor/Armor1.png")
	
	self.description = _description
	
	if (_rarity):
		self.rarity = _rarity
	else: 
		self.rarity = RandomStats.random_rarity()

	if (_name):
		self.name = _name
	else:
		self.name = 'Glovess'

	item_stats["Physical Defense"] = 0
	item_stats["Magic Defense"] = 0
	item_stats["Evasion"] = 0
	
	generate_modifiers()

func get_item_type():
	return Enums.EItemType.GLOVES

func get_equip_type():
	return Enums.EEquipType.GLOVES

func get_slot_type():
	return [Enums.EEquipmentSlot.GLOVES]

func is_equipable()->bool:
	return true

