extends Actor
class_name PlayerScript

signal dropped_inventory_opened(item_array: Array[Item])
signal dialogue_started(with: String)
signal dialogue_ended()
signal dialogue_continue(choice: int)
signal skill_used(skill_id: int)
signal kill_confirmed(who: Actor)
signal money_earned(much: int)


var invincible_timer = null
var player_state: Enums.EPlayerState = Enums.EPlayerState.ROAMING
var interaction_target = null

@onready var viewer_manager = ViewerManager.new()

var battle_timer = null

@onready var MeleeTriggerArea: Area2D = $MeleeTriggerArea
@onready var SceneManager = self.get_tree().get_root().find_child("SceneManager", true, false)


func save():
	SceneManager.save_resource(self.data, 'user://player_data.res')

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
	
	data.skills.add_skill(GlobalSkills.get_by_name('Javelin'))
	data.skills.add_skill(GlobalSkills.get_by_name('Pierce'))
	data.skills.add_skill(GlobalSkills.get_by_name('Fire Armament'))
	data.skills.add_skill(GlobalSkills.get_by_name('Strike'))
	data.skills.add_skill(GlobalSkills.get_by_name('Double Slash'))





	cooldown(20)
	
	save()
	var loaded_data = SceneManager.load_resource('user://player_data.res')
	print(loaded_data)
	if loaded_data is PlayerData: # Check that the data is valid
		print(';succ')


	reload_battle_timer()
	
	
func _physics_process(_delta):
	super(_delta)
	#print(battle_timer.time_left)
	#print(viewer_manager.get_overall_satisfaction())
	if battle_timer.time_left <= 2.0:
		battle_timer.start()
	

					
func reload_battle_timer():
	if not self.battle_timer:
		battle_timer = Timer.new()
		battle_timer.set_wait_time(5)
		battle_timer.set_one_shot(true)
		battle_timer.connect("timeout", _on_battle_timer_end)  
		self.add_child(battle_timer)
		battle_timer.start()
		
func _on_battle_timer_end():
	print('end')
	#battle_timer.start()

func set_zone(to):
	current_zone = to
	#print('player in ' + str(to))
	
func _on_chest_open(chest):
	emit_signal("dropped_inventory_opened", chest.chest_inventory)

func _on_interaction_zone_entered(what: Area2D):
	#print(what.get_parent())
	if what.get_parent() != self:
		what.get_parent().on_interact_area()
	
func _on_interaction_zone_exited(what: Area2D):
	#print(what.get_parent())
	if what.get_parent() != self:
		what.get_parent().off_interact_area()
	

func use_skill_id(id: int):
	if id < data.skills.get_skills().size():
		if (data.skills.get_skill_id(id).get_cost() <= data.stamina):
			data.stamina -= data.skills.get_skill_id(id).get_cost()
			emit_signal("skill_used", id)
			shoot_projectile( data.skills.get_skill_id(id))
			for status in data.skills.get_skill_id(id).status_self:
				self.initiate_status(data.skills.get_skill_id(id), status, data.skills.get_skill_id(id).status_duration)

#			match data.skills.get_skill_id(id).get_skill_type(): 
#				'Attack':
#					shoot_projectile( data.skills.get_skill_id(id))
#				'Status':
#					use_status_skill( data.skills.get_skill_id(id))

	
func interact_with_nearest():
	match self.player_state:
		Enums.EPlayerState.ROAMING:
			if interaction_target:
				interaction_target.interact()
			elif (interaction_area.get_overlapping_areas()):
				interaction_area.get_overlapping_areas()[0].get_parent().interact()
		Enums.EPlayerState.TALKING:
			self.emit_signal("dialogue_continue", 0)
#		if interaction_area.get_overlapping_areas()[0].get_parent().get_class() == "CharacterBody2D":
#			trigger_dialogue(interaction_area.get_overlapping_areas()[0].get_parent())

#func trigger_dialogue(with):
#	interaction_target = with
#
#	var dialogue_text = with.get_dialogue()
#
#	if dialogue_text == null:
#		interaction_target = null
#		player_state = Enums.EPlayerState.ROAMING
#		with.current_state = Enums.ECharacterState.ROAMING
#		self.emit_signal("dialogue_ended")
#	else:
#		print("Dialogue with " + str(with))
#		self.emit_signal("dialogue_started", with.npc_name, dialogue_text)
#		self.player_state = Enums.EPlayerState.TALKING
#		with.current_state = Enums.ECharacterState.TALKING
	


func kill_confirm(who):
	self.viewer_manager.action_to_viewers(Enums.EViewerAction.SLAY, 1)
	emit_signal("kill_confirmed", who)
	money_earn(20)
	
func money_earn(much):
	self.data.money += much
	emit_signal("money_earned", much)
	
func get_collider_type():
	return 'Player'
	
	
func trigger_melee():
	var melee_enemies = []
	for obj in MeleeTriggerArea.get_overlapping_areas():
		if obj.get_parent().get_collider_type() == 'NPS':
			melee_enemies.append(obj.get_parent())
	print(melee_enemies)
	SceneManager.add_melee(self, melee_enemies)
	player_state = Enums.EPlayerState.MELEE
	
	

