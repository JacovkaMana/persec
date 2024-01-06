class_name BaseConsumableItem
extends BaseStackableItem

@export var effects: Array[Enums.EItemEffectType]

func get_item_type()->int: #Enums.EItemType:
	return Enums.EItemType.CONSUMABLE

func get_type_text()->String:
		return "Consumable"

func get_item_actions():
	return [Enums.EItemActions.USE ,Enums.EItemActions.DROP]
