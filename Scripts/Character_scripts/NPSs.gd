extends Actor
@export var npc_name: String = ""
#stats
@export_category('Stats')
@export var STRENGTH: int = 0
@export var DEXTERITY: int = 0
@export var CONSTITUTION: int = 0
@export var INTELLIGENCE: int = 0
@export var PERCEPTION: int = 0
@export var CHARISMA: int = 0


#weapons
@export_category('Equipment')
@export var L_HAND: WeaponItem = null
@export var R_HAND: WeaponItem = null

#right armor
@export var HELM: HelmItem = null
@export var ARMOR: ArmorItem = null
@export var GLOVES: GlovesItem = null
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

var walk_radius: float = 50
var last_direction_change: float = 0
#@onready var raycast: ShapeCast2D = $RayCast
#@onready var path: Path2D = $Path2D
#@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
#@onready var path_player = $PathPlayer
@onready var vision: Area2D = $Vision
@onready var interaction_hint = $InteractionHint
@onready var interaction_hint_player = $InteractionHint/AnimationPlayer
@onready var player = get_tree().get_root().find_child("Player", true, false)

var current_state : Enums.ECharacterState = Enums.ECharacterState.ROAMING
var start_pos: Vector2 = Vector2.ZERO
var dialogue_number: int = 0


var select_material = preload("res://Art/Shaders/HighlightShader.tres")
var Chest = preload("res://Scenes/Objects/chest.tscn")




func _ready():
	super()
	
	
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
		print(collision)
		
	vision.connect("body_entered", _on_vision_enter) 
	vision.connect("body_exited", _on_vision_exit) 

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
		_:
			pass



	
	vision.rotation = move_direction.angle() + PI
	
func get_dialogue():
	var path = "res://Data/" + self.npc_name + '.json'
	var file = FileAccess.open(path, FileAccess.READ)
	var dialogue: Dictionary = JSON.parse_string(file.get_as_text())
	if (str(dialogue_number + 1) in dialogue.keys()):
		dialogue_number += 1
		print(dialogue[str(dialogue_number)].text)

	
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
	print('nps at ' + str(current_zone))
	
func _on_vision_enter(who):
	if (who == player):
		label.text = "!"
		label.visible = true
		
func _on_vision_exit(who):
	if (who == player):
		label.text = "?"
		label_timer(3)
		
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
	

func take_damage(_skill: BaseSkill, _strength):
	super(_skill, _strength)
	if (data.hitpoints <= 0):
		print('death')
		animation_tree.set("parameters/death/transition_request", "true")
	pass

func _on_anim_finished(name):
	print(name)
	if (name == "death"):
		var death_chest = Chest.instantiate()
		
		self.get_parent().add_child(death_chest)
		death_chest.global_position = self.global_position
		death_chest.chest_inventory = self.data.inventory.get_inventory_items()
		self.queue_free()

func interact():
	get_dialogue()
