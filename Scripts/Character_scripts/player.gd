extends Actor
class_name PlayerScript

signal dropped_inventory_opened(item_array: Array[Item])
signal dialogue_started(with: CharacterBody2D)
signal skill_used(skill_id: int)

var invincible_timer = null
var player_state: Enums.EPlayerState = Enums.EPlayerState.ROAMING

func _ready():
	super()
	InputManager.player = self
	
	interaction_area.connect("area_entered", _on_interaction_zone_entered)
	interaction_area.connect("area_exited", _on_interaction_zone_exited)
	
	var test_item = WeaponItem.new()
	for i in range(5):
		test_item = WeaponItem.new(
		'',
		'from player',
		null,
		0,
		30
		)
		data.inventory.add_item(test_item)
		
	var test_armor = ArmorItem.new(
		'Armor',
		'From player',
	)
	data.inventory.add_item(test_armor)
	
	var test_boots = BootsItem.new(
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
	
	print(interaction_area)


	
	data.inventory.equip_item(test_item)
	
	data.skills.add_skill(GlobalSkills.skills['Slash'])
	data.skills.add_skill(GlobalSkills.skills['Fireball'])
	data.skills.add_skill(GlobalSkills.skills['Ice Slash'])
	print(data.skills.get_skills())




	cooldown(20)

func _physics_process(_delta):
	super(_delta)
					

func set_zone(to):
	current_zone = to
	#print('player in ' + str(to))
	
func _on_chest_open(chest):
	emit_signal("dropped_inventory_opened", chest.chest_inventory)

func _on_interaction_zone_entered(what: Area2D):
	#print(what.get_parent())
	what.get_parent().on_interact_area()
	
func _on_interaction_zone_exited(what: Area2D):
	#print(what.get_parent())
	what.get_parent().off_interact_area()
	

func use_skill_id(id: int):
	if id < data.skills.get_skills().size():
		if (data.skills.get_skill_id(id).get_cost() <= data.stamina):
			data.stamina -= data.skills.get_skill_id(id).get_cost()
			emit_signal("skill_used", id)
			shoot_projectile(
				data.skills.get_skill_id(id)
			)

	
func interact_with_nearest():
	if (interaction_area.get_overlapping_areas()):
		interaction_area.get_overlapping_areas()[0].get_parent().interact()
		if interaction_area.get_overlapping_areas()[0].get_parent().get_class() == "CharacterBody2D":
			trigger_dialogue(interaction_area.get_overlapping_areas()[0].get_parent())

func trigger_dialogue(with):
	print("Dialogue with " + str(with))
	emit_signal("dialogue_started", with)
	self.player_state = Enums.EPlayerState.TALKING
	with.current_state = Enums.ECharacterState.TALKING
	

