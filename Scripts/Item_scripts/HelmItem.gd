class_name HelmItem
extends BaseEquipableItem

@export var armor_type: Enums.EArmorType = Enums.EArmorType.NONE

func get_item_type():
	return Enums.EItemType.HELM

func get_equip_type():
	return Enums.EEquipType.HELM
	
func get_type_text()->String:
		return "Helm"

func get_slot_type():
	return [Enums.EEquipmentSlot.HELM]
	

func is_equipable()->bool:
	return true


func _init(_name: String = '', _description: String = '', _rarity = null):
	
	self.armor_type = Enums.EArmorType.PLATE
	var sprites = GlobalSprites.helm[self.armor_type]
	sprite = sprites[randi() % sprites.size()]
	
	self.description = _description
	
	if (_rarity):
		self.rarity = _rarity
	else: 
		self.rarity = RandomStats.random_rarity()

	if (_name):
		self.name = _name
	else:
		self.name = 'Helmm'
		
	item_stats["Physical Defense"] = 0
	item_stats["Magic Defense"] = 0
	item_stats["Evasion"] = 0
		
	generate_modifiers()
