extends Node

var potions = {
	
}

func _init():
	
	potions['small_potion'] = create_potion(
		'Small potion',
		'Heals a small amount of health',
		1
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func create_potion(_name: String, _description: String, _rarity: int):
	var potion = BaseConsumableItem.new(
		_name,
		_description,
		_rarity
	)
	potion.sprite = preload("res://Art/Sprites/Stackable/HealthPotion1.png")
	return potion
