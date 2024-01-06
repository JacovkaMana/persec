class_name Item
extends Resource


@export var name: String = "NOT"
@export var sprite: Texture2D = null
@export var description: String = "INITIALIZED"
@export var rarity: Enums.ERarity = Enums.ERarity.Common


@export var weight: float = 0.0
@export var base_cost: float = 0.0

func _init(_name: String = '', _description: String = '', _rarity = null):
	
	if(_name):
		self.name = _name
		
	if(_description):
		self.description = _description
	
	if(_rarity):
		self.rarity = _rarity


	
func is_stackable()->bool:
	return false

func get_item_actions():
	return [Enums.EItemActions.DROP]

func get_item_type():
	return Enums.EItemType.ITEM
	
func get_slot_type(): 
	return [null]

func get_type_text()->String:
	return "Item"

func get_common_properties()->Array: #[ItemProperty]:
	return []

func is_equipable()->bool:
	return false

func _randomize()->bool:
	return true
	


