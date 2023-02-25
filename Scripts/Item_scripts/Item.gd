class_name Item
extends Resource


@export var name: String = "NOT"
@export var sprite: Texture2D = null
@export var description: String = "INITIALIZED"
@export var rarity: Enums.ERarity = Enums.ERarity.Common

@export var effects: Array[Enums.EItemEffectType]

@export var weight: float = 0.0
@export var base_cost: float = 0.0



func initialize(name: String = '', description: String = '', rarity = null):
	
	if(name):
		self.name = name
		
	if(description):
		self.description = description
	
	if(rarity):
		self.rarity = rarity
	
func is_stackable()->bool:
	return false


func get_item_type():
	return Enums.EItemType.ITEM
	
func get_slot_type(): 
	return [null]

func get_type_text()->String:
	return "Item"

func get_common_properties()->Array: #[ItemProperty]:
	return []


func randomize()->bool:
	return true
