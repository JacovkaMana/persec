class_name Item
extends Resource


@export var name: String = "NOT"
@export var icon: Texture2D
@export var description: String = "INITIALIZED"
@export var rarity: int = 1

@export var effects: Array[Enums.EItemEffectType]

@export var weight: float = 0.0
@export var base_cost: float = 0.0



func initialize(name: String, description: String, rarity: int = 1):
	self.name = name
	self.description = description
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
