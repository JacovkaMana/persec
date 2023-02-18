extends Actor
class_name Player

var invincible_timer = null

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
		data.inventory.add_item(test_item)
		
	var test_armor = ArmorItem.new()
	test_armor.initialize(
		'Armor',
		'From player',
	)
	data.inventory.add_item(test_armor)
	
	var test_boots = BootsItem.new()
	test_boots.initialize(
		'Boots',
		'From player',
	)
	data.inventory.add_item(test_boots)
	
	if not data.inventory.is_initialized():
		for stat in data.stats.keys():
			data.stats[stat] = 7
		data.inventory._is_initialize = true
		
	var test_item_stackable = StackableItems.potions.small_potion

		
	for i in range(5):
		data.inventory.add_item(test_item_stackable)
		


	
	data.inventory.equip_item(test_item)
	
	data.skills.add_skill(GlobalSkills.skills['Slash'])
	data.skills.add_skill(GlobalSkills.skills['Fireball'])
	data.skills.add_skill(GlobalSkills.skills['Ice Slash'])
	print(data.skills.get_skills())


	cooldown(20)

func _physics_process(_delta):
	super(_delta)
	move_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") -  Input.get_action_strength("up")
)


func _input(event):
	#if event.is_action_pressed("shoot"):
		#use_skill_id(2)
		
	if event.is_action_pressed("skill1"):
		use_skill_id(0)
	if event.is_action_pressed("skill2"):
		use_skill_id(1)
	if event.is_action_pressed("skill3"):
		use_skill_id(2)
			
