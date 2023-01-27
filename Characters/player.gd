extends Actor
class_name Player


func _ready():
	super()
	var test_item = WeaponItem.new()
	for i in range(5):
		test_item = WeaponItem.new()
		test_item.initialize(
		'',
		'from player',
		null,
		null,
		30
		)
		print(test_item.modifiers[0].text)
		inventory.add_item(test_item)
	
	if not  inventory.is_initialized():
		for stat in inventory._stats.keys():
			inventory._stats[stat] = 7
		inventory._is_initialize = true
		
	print(inventory._stats)
	var test_item_stackable = StackableItems.potions.small_potion

		
	for i in range(5):
		inventory.add_item(test_item_stackable)
		


	print(inventory.get_inventory_items(Enums.EItemType.WEAPON))
	
	inventory.equip_item(test_item)
	print(inventory._equipment)


func _physics_process(_delta):
	super(_delta)
	move_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") -  Input.get_action_strength("up")
)

	#print(get_viewport().get_mouse_position())
