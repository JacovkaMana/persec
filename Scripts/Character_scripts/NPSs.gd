extends Actor
class_name NPS


@export var npc_name: String = "FirstGuard"
@export var behaviuor: Enums.ECharacterBehaviour
@export var fight_ai : BaseAI = BaseAI.new()
@export var interaction_list: Array[Enums.ECharacterActions] = []

@export var default_state: Enums.ECharacterState = Enums.ECharacterState.IDLE
@export var starting_zone: ZoneScript


@export_category('Stats')
@export var max_hitpoins: int = 100
@export var hitpoints: int = 100
@export var Stamina_max: int = 3
@export var Stamina_regen: int = 10
@export var nps_stats: Dictionary = {
	Enums.EStat.STRENGTH: 5,
	Enums.EStat.DEXTERITY: 5,
	Enums.EStat.CONSTITUTION: 5,
	Enums.EStat.INTELLIGENCE: 5,
	Enums.EStat.PERCEPTION: 5,	
	Enums.EStat.CHARISMA: 5,	
}

@export_category('Inventory')
@export var random_items: int = 0
@export var static_items : Array[Item] = []
@export_category('Skills')
@export var SKILLS: Array[String] = []


var walk_radius: float = 50
var last_direction_change: float = 0
#@onready var raycast: ShapeCast2D = $RayCast
#@onready var path: Path2D = $Path2D
#@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
#@onready var path_player = $PathPlayer
@onready var vision_idle: Area2D = $VisionIdle
@onready var vision_battle: Area2D = $VisionBattle

var vision

@onready var interaction_hint = $InteractionHint
@onready var interaction_hint_player = $InteractionHint/AnimationPlayer
@onready var player = get_tree().get_root().find_child("Player", true, false)

@onready var nps_hud = $HUD

var current_state : Enums.ECharacterState
var start_pos: Vector2 = Vector2.ZERO
var start_rotation: Vector2 = Vector2.from_angle( randi_range(0, 360) )
var dialogue_number: int = 0


var select_material = preload("res://Art/Shaders/HighlightShader.tres")
var Chest = preload("res://Scenes/Objects/chest.tscn")

var last_vision = []

@onready var raycast = $RayCast2D
@onready var collision_map = $"../CollisionMap"


@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D


func _ready():
	super()
	if len(interaction_list) > 0:
		self.add_to_group('interactable')
	
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)

	start_pos = self.position
	
	var timer = Timer.new()
	timer.set_wait_time(5)
	timer.set_one_shot(false)
	add_child(timer)
	timer.start()
	
	if (not self.get_collision_mask_value(7)):
		self.set_collision_mask_value(7, true)
		collision = move_and_collide(Vector2(0,0))
		
	#vision.connect("body_entered", _on_vision_enter) 
	#vision.connect("body_exited", _on_vision_exit) 

	for i in range(random_items):
		var random_item
		if randi() % 2 == 1:
			random_item = RandomStats.random_armor.pick_random().new(
				'',
				'random generated',
				''
			)
		else:
			random_item = WeaponItem.new(
		'',
		'random generated',
		null,
		0,
		30
		)
		self.data.inventory.add_item(random_item)
		
	vision = vision_idle
	
	
	
	# Initiate NPS Data
	data = PlayerData.new()
	
	data.stats = nps_stats
	data.hitpoints = hitpoints
	data.max_hitpoints = max_hitpoins
	data.stamina_regen = Stamina_regen
	data.max_stamina = Stamina_max
	
	
	for skill_string in SKILLS:
		data.skills.add_skill(GlobalSkills.get_by_name(skill_string))
		
	self.move_direction = self.start_rotation
	self.fight_ai.owner = self

	self.move_direction = Vector2(1, 0)


	self.raycast.add_exception(self)
	self.raycast.add_exception(player)
	
	
	
	self.nav_agent.target_position = self.starting_zone.get_random_pos()
	self.nav_agent.connect("target_reached", self.fight_ai.set_roam_timer) 
	
	self.reset_state()
	
func _physics_process(_delta):
	super(_delta)
	
#	if self.global_position.y < player.global_position.y:
#		self.z_index = 4
#	else:
#		self.z_index = 6
	
	#print(current_state)
	match (current_state):
		Enums.ECharacterState.IDLE:
			pass
		Enums.ECharacterState.ROAMING:
#			if(current_zone):
#				if (current_zone.follow_position - self.global_position).length() < 2.0:
#					move_direction = Vector2(0, 0)
#				else:
#					move_direction = (current_zone.follow_position - self.global_position).normalized()
			
			

			#else:
			#	print(self.name, self.nav_agent.get_current_navigation_result().path)
			#if current_zone:
				#print(current_zone.collision_shapes[0].shape.extents)
			self.fight_ai.roam()
			#print('roam')
		Enums.ECharacterState.TALKING:
			self.move_direction = Vector2(0, 0);
		Enums.ECharacterState.FIGHT_RANGE:
			
			
			#self.move_direction = Vector2(0, 0);
			
			self.fight_ai.ai_process(_delta)
			#self.fight_ai.ai_vision_process(vision.get_overlapping_bodies())
		Enums.ECharacterState.SEARCHING:
			#self.move_direction = Vector2(0, 0);
			pass
		_:
			pass

	var current_vision = vision.get_overlapping_bodies()
	if current_vision != last_vision:
	
		for who in current_vision:
			if who not in last_vision:
				_on_vision_enter(who)
								
		for who in last_vision:
			if who not in current_vision:
				_on_vision_exit(who)
						
	last_vision = current_vision


	
	vision.rotation = move_direction.angle() + PI
	
func get_dialogue():
	var path = "res://Data/" + self.npc_name + '.json'
	var file = FileAccess.open(path, FileAccess.READ)
	var dialogue: Dictionary = JSON.parse_string(file.get_as_text())
	if (str(dialogue_number + 1) in dialogue.keys()):
		dialogue_number += 1
		return dialogue[str(dialogue_number)].text
	else:
		dialogue_number = 0
		return null

	
func on_interact_area():
	interaction_hint_player.queue("float")
	interaction_hint.visible = true
	
func off_interact_area():
	interaction_hint_player.queue("RESET")
	interaction_hint.visible = false
	
func _on_mouse_entered():
	#self.material = select_material
	animation_tree.set("parameters/glow/add_amount", 1)
	nps_hud.visible = true
	
	
	
func _on_mouse_exited():
	#sprite.material = null
	animation_tree.set("parameters/glow/add_amount", 0)
	nps_hud.visible = false
	
	
func reset_state():
	self.current_state = self.default_state

func _on_vision_enter(who):
	match who.get_collider_type():
		'Player':
			if(self.behaviuor == Enums.ECharacterBehaviour.HOSTILE):
				label.text = "!"
				label.visible = true
				self.vision = vision_battle
				self.fight_ai.setup(self, who)
				self.current_state = Enums.ECharacterState.FIGHT_RANGE
				self.look_at = player
				
		'Projectile':
			if (who.projectile_owner != self):
				if(self.behaviuor == Enums.ECharacterBehaviour.HOSTILE):
					
					self.fight_ai.setup(self, who.projectile_owner)
					self.current_state = Enums.ECharacterState.FIGHT_RANGE
					self.fight_ai.projectile_coming(who)
					self.look_at = player
		
		
func _on_vision_exit(who):
	if is_instance_valid(who):
		match who.get_collider_type():
			'Player':
					label.text = "?"
					label.visible = true
			'Projectile':
				if(self.current_state == Enums.ECharacterState.FIGHT_RANGE):
					self.fight_ai.projectile_exited(who)
		
func label_timer(time):
	
	var _timer = Timer.new()
	label.visible = true


	_timer.set_wait_time(time)
	_timer.set_one_shot(true)
	_timer.connect("timeout", _hide_label)  
	add_child(_timer)
	_timer.start()
	
func _hide_label():
	label.visible = false
	

func take_damage(_skill: Skill, _from: Actor, _strength):
	super(_skill, _from, _strength)
	if (data.hitpoints <= 0):
		die()
		
func die():
	self.move_direction = Vector2(0, 0)
	self.look_at = null
	self.move_speed = 0
	self.freeze = true
	animation_tree.set("parameters/death/transition_request", "true")
	player.kill_confirm(self)
	print('die')

func _on_anim_finished(_name):
	match _name:
		"death":
			var death_chest = Chest.instantiate()
			
			self.move_direction = Vector2(0, 0)
			self.look_at = null
			self.get_parent().add_child(death_chest)
			death_chest.created_by = self
			death_chest.global_position = self.global_position
			death_chest.chest_inventory = self.data.inventory.get_inventory_items()
			death_chest.chest_inventory.append_array(self.static_items)
			if len(death_chest.chest_inventory) == 0:
				death_chest.queue_free()
			self.queue_free()

func interact():
	if Enums.ECharacterActions.TALK in self.interaction_list:
			#player.trigger_dialogue(self)
			player.emit_signal("dialogue_started", self)
	return null

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
	
	
func get_collider_type():
	return 'NPS'
