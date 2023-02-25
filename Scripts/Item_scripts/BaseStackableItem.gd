class_name BaseStackableItem
extends Item

@export var max_count: int = 10
@export var max_stored_count: int = 600
@export var count: int = 1


func is_stackable()->bool:
	return true
