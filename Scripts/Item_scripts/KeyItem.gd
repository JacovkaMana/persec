class_name KeyItem
extends Item

@export var stackable: bool = false
@export var keyitem_name: String = ''

func get_item_type()->int: #Enums.EItemType:
	return Enums.EItemType.KEY

func get_type_text()->String:
		return "Key"

func get_item_actions():
	return [Enums.EItemActions.USE ,Enums.EItemActions.DROP]
	

func is_stackable()->bool:
	return stackable


