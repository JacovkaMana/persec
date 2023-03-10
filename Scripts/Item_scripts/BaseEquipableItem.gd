class_name BaseEquipableItem
extends Item

@export var max_durability: float = 1.0
@export var modifiers: Array[Modifier] = []

func get_item_actions():
	return [Enums.EItemActions.EQUIP, Enums.EItemActions.DROP]
