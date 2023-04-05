extends Actor
class_name PlayerScript

signal dropped_inventory_opened(item_array: Array[Item])
signal dialogue_started(with: String, text: String)
signal dialogue_ended()
signal skill_used(skill_id: int)
signal kill_confirmed(who: Actor)
signal money_earned(much: int)


var invincible_timer = null
var player_state: Enums.EPlayerState = Enums.EPlayerState.ROAMING

func _ready():
	super()
	InputManager.player = self
	data.recalculate_stats()
	
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
	
#	if not data.inventory.is_initialized():
#		for stat in data.stats.keys():
#			data.stats[stat] = 7
#		data.inventory._is_initialize = true
		
	var test_item_stackable = StackableItems.potions.small_potion

		
	for i in range(5):
		data.inventory.add_item(test_item_stackable)
	



	
	data.inventory.equip_item(test_item)
	
	data.skills.add_skill(GlobalSkills.skills['Defend'])
	data.skills.add_skill(GlobalSkills.skills['Fireball'])
	data.skills.add_skill(GlobalSkills.skills['Ice Strike'])
	data.skills.add_skill(GlobalSkills.skills['Ice Slash'])





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
			
			match data.skills.get_skill_id(id).get_skill_type(): 
				'Attack':
					shoot_projectile( data.skills.get_skill_id(id))
				'Status':
					use_status_skill( data.skills.get_skill_id(id))

	
func interact_with_nearest():
	if (interaction_area.get_overlapping_areas()):
		interaction_area.get_overlapping_areas()[0].get_parent().interact()
#		if interaction_area.get_overlapping_areas()[0].get_parent().get_class() == "CharacterBody2D":
#			trigger_dialogue(interaction_area.get_overlapping_areas()[0].get_parent())

func trigger_dialogue(with):
	var dialogue_text = with.get_dialogue()
	print(dialogue_text)
	if dialogue_text == null:
		player_state = Enums.EPlayerState.ROAMING
		with.current_state = Enums.ECharacterState.ROAMING
		emit_signal("dialogue_ended")
	else:
		print("Dialogue with " + str(with))
		emit_signal("dialogue_started", with.npc_name, dialogue_text)
		self.player_state = Enums.EPlayerState.TALKING
		with.current_state = Enums.ECharacterState.TALKING
	


func kill_confirm(who):
	emit_signal("kill_confirmed", who)
	money_earn(20)
	
func money_earn(much):
	self.data.money += much
	emit_signal("money_earned", much)
	
