extends Actor
class_name NPS

@export var npc_name: String = ""
@export var behaviuor: Enums.ECharacterBehaviour
@export var fight_ai : BaseAI
#stats
@export_category('Stats')
@export var STRENGTH: int = 0
@export var DEXTERITY: int = 0
@export var CONSTITUTION: int = 0
@export var INTELLIGENCE: int = 0
@export var PERCEPTION: int = 0
#@export var CHARISMA: int = 0


#weapons
@export_category('Equipment')
@export var L_HAND: WeaponItem = null
@export var R_HAND: WeaponItem = null

#right armor
@export var HELM: HelmItem = null
@export var ARMOR: ArmorItem = null
@export var PANTS: PantsItem = null
@export var BOOTS: BootsItem = null
#left armor
@export var AMULET: Item = null
@export var BELT: Item = null
@export var ACCESSORY_1: Item = null
@export var ACCESSORY_2: Item = null

@export_category('Inventory')
@export var random_items: int = 0
var INVENTORY : Array[Item] = []
@export_category('Skills')
@export var SKILLS: Array[String] = []
@export var Stamina_max: int = 3
@export var Stamina_regen: int = 20

@export var interaction_list: Array[Enums.ECharacterActions] = []

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

var current_state : Enums.ECharacterState = Enums.ECharacterState.ROAMING
var start_pos: Vector2 = Vector2.ZERO
var dialogue_number: int = 0


var select_material = preload("res://Art/Shaders/HighlightShader.tres")
var Chest = preload("res://Scenes/Objects/chest.tscn")

var last_vision = []


func _ready():
	super()
	add_to_group('interactable')
	
	#self.connect("mouse_entered", _mouse_entered)
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
	
	
	for skill_string in SKILLS:
		data.skills.add_skill(GlobalSkills.skills[skill_string])
		
		
	data.max_stamina = Stamina_max
	data.stamina_regen = Stamina_regen
	self.fight_ai = MageAI.new()
	
func _physics_process(_delta):
	super(_delta)
	
	match (current_state):
		Enums.ECharacterState.IDLE:
			pass
		Enums.ECharacterState.ROAMING:
			if(current_zone):
				if (current_zone.follow_position - self.global_position).length() < 2.0:
					move_speed = 0
				else:
					move_direction = (current_zone.follow_position - self.global_position).normalized()
					move_speed = 70
		Enums.ECharacterState.TALKING:
			self.move_direction = Vector2(0, 0);
		Enums.ECharacterState.FIGHT_RANGE:
			#self.fight_ai.ai_vision_process(vision.get_overlapping_bodies())
			self.fight_ai.ai_process(_delta)
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
	
	
func _on_mouse_exited():
	#sprite.material = null
	animation_tree.set("parameters/glow/add_amount", 0)
	
	
func set_zone(to : Area2D):
	current_zone = to
	#print('nps at ' + str(current_zone))
	
func _on_vision_enter(who):
	match who.get_collider_type():
		'Player':
			if(self.behaviuor == Enums.ECharacterBehaviour.HOSTILE):
				label.text = "!"
				label.visible = true
				self.vision = vision_battle
				self.fight_ai.setup(self, who)
				self.current_state = Enums.ECharacterState.FIGHT_RANGE
				
		'Projectile':
			if (who.projectile_owner != self):
				if(self.behaviuor == Enums.ECharacterBehaviour.HOSTILE):
					
					self.fight_ai.setup(self, who.projectile_owner)
					self.current_state = Enums.ECharacterState.FIGHT_RANGE
					self.fight_ai.projectile_coming(who)
		
		
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
	

func take_ranged_damage(_skill: AttackSkill, _from: Actor, _strength):
	super(_skill, _from, _strength)
	if (data.hitpoints <= 0):
		animation_tree.set("parameters/death/transition_request", "true")
		player.kill_confirm(self)

func _on_anim_finished(name):
	if (name == "death"):
		var death_chest = Chest.instantiate()
		
		self.get_parent().add_child(death_chest)
		death_chest.created_by = self
		death_chest.global_position = self.global_position
		death_chest.chest_inventory = self.data.inventory.get_inventory_items()
		self.queue_free()

func interact():
	if Enums.ECharacterActions.TALK in self.interaction_list:
			player.trigger_dialogue(self)
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
