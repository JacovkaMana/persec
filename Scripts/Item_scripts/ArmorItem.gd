class_name ArmorItem
extends BaseEquipableItem

@export var armor_type: Enums.EArmorType = Enums.EArmorType.NONE



func get_type_text()->String:
		return "Armor"

func _init(_name: String = '', _description: String = '', _rarity = null):
	
	self.armor_type = Enums.EArmorType.PLATE
	var sprites = GlobalSprites.armor[self.armor_type]
	sprite = sprites[randi() % sprites.size()]
	
	self.description = _description
	
	if (_rarity):
		self.rarity = _rarity
	else: 
		self.rarity = RandomStats.random_rarity()

	if (_name):
		self.name = _name
	else:
		self.name = 'Arrmor'

	match self.armor_type:
		Enums.EArmorType.CLOTH:
			item_stats["Magic Defense"] = self.item_level
			item_stats["Evasion"] = self.item_level
		Enums.EArmorType.LEATHER:
			item_stats["Physical Defense"] = self.item_level
			item_stats["Evasion"] = self.item_level
		Enums.EArmorType.PLATE:
			item_stats["Physical Defense"] = self.item_level
			item_stats["Magic Defense"] = self.item_level
	
	generate_modifiers()


func get_item_type():
	return Enums.EItemType.ARMOR
	
func get_equip_type():
	return Enums.EEquipType.ARMOR

func get_slot_type():
	return [Enums.EEquipmentSlot.ARMOR]

func is_equipable()->bool:
	return true

