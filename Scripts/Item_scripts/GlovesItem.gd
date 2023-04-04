class_name GlovesItem
extends BaseEquipableItem


@export var armor_type: Enums.EArmorType = Enums.EArmorType.NONE


func get_type_text()->String:
		return "Armor"

func _init(_name: String = '', _description: String = '', _rarity = null):
	
	self.armor_type = Enums.EArmorType.PLATE
	var sprites = GlobalSprites.pants[self.armor_type]
	sprite = sprites[randi() % sprites.size()]
	
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

