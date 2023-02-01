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
		0,
		30
		)
		inventory.add_item(test_item)
		
	var test_armor = ArmorItem.new()
	test_armor.initialize(
		'Armor',
		'From player',
	)
	inventory.add_item(test_armor)
	
	var test_boots = BootsItem.new()
	test_boots.initialize(
		'Boots',
		'From player',
	)
	inventory.add_item(test_boots)
	
	if not  inventory.is_initialized():
		for stat in inventory._stats.keys():
			inventory._stats[stat] = 7
		inventory._is_initialize = true
		
	var test_item_stackable = StackableItems.potions.small_potion

		
	for i in range(5):
		inventory.add_item(test_item_stackable)
		


	
	inventory.equip_item(test_item)


func _physics_process(_delta):
	super(_delta)
	move_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") -  Input.get_action_strength("up")
)

	#print(get_viewport().get_mouse_position())
