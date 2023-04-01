class_name HelmItem
extends BaseEquipableItem

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
	
	sprite = preload("res://Art/Sprites/Boots/Boots1.png")
	
	self.description = _description
	
	if (_rarity):
		self.rarity = _rarity
	else: 
		self.rarity = RandomStats.random_rarity()

	if (_name):
		self.name = _name
	else:
		self.name = 'Helmm'
		
	generate_modifiers()
