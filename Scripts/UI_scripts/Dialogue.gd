extends Control

@onready var inventory_grid: GridContainer = $InventoryGrid
@onready var player = get_tree().get_root().find_child("Player", true, false)
@onready var desc_panel: Panel = $ItemDescPanel
@onready var actions_panel: Panel = get_tree().get_root().find_child("ItemActionsPanel", true, false)

#@export var dialogue_choice = preload("res://Scenes/Objects/dialogue_choice.tscn")
@export var action_choice = preload("res://Scenes/Objects/action_choice.tscn")

@onready var choices_array = $Choices
@onready var actions_array = $Actions

var active_item_lclick: Item = null
var active_slot_rclick: BaseSlotUI = null
var panel_hover = false
var ItemButton = preload("res://Scenes/Inventory/ItemButton.tscn")
@onready var tween = self.create_tween()

@onready var ui_settings = $"../.."
@onready var hud_settings = $"../../HUD"
@onready var bground = $Background
@onready var shadow = $Shadow
@onready var name_label = $Label
@onready var text_label = $RichTextLabel


var dialogue_path = "res://Data/Dialogues/%s.json"
var dialogue_json = null
var current_id = null
var current_answers = {}
var current_with = null
var current_text = null
var current_text_progression = null

var fight_choice_icon = preload("res://Art/UI/choice_fight.png")
var speak_choice_icon = preload("res://Art/UI/choice_speak.png")
var trade_choice_icon = preload("res://Art/UI/choice_trade.png")

var is_talking = false
var choices_visible = false

@onready var audio_player = $AudioStreamPlayer2D

var skip = false
var skip_count = 0
var odd = 0
	
func _ready():
	
	player.connect("dialogue_started", _on_dialogue)
	player.connect("dialogue_ended", _on_dialogue_ended)
	player.connect("dialogue_continue", _on_dialogue_continue)
	
	audio_player.bus = 'Dialogue'
	audio_player.volume_db = -50.0
	audio_player.set_stream(load("res://Sounds/sfx-blipmale.wav"))

	
func _physics_process(_delta):
	var stop_symbols = {
		'#' : 10,
		'.' : 10,
		',' : 10,
		'?' : 10,
		'!' : 10, 
		' ' : 1
		}
	
	
	
	if self.text_label.visible_characters < self.text_label.get_total_character_count():
		
		if odd == 0:
			if self.text_label.text[self.text_label.visible_characters] in stop_symbols.keys():
				odd = stop_symbols[self.text_label.text[self.text_label.visible_characters]]
				self.text_label.visible_characters += 1
			else:
				self.text_label.visible_characters += 1
				audio_player.play()
				odd = 3
				
				
		odd -= 1
				
			
	if not choices_visible:
		self._on_talking_choices(current_answers.keys())
		choices_visible = true


func set_text_label(text):
	
	
	self.text_label.text = text
	self.text_label.visible_characters = 0	
	self._remove_choise()
	choices_visible = false
	
	
	
func _on_dialogue(with):
	
	dialogue_json = load(dialogue_path % with.npc_name)
	
	self.current_with = with
	
	self.player.player_state = Enums.EPlayerState.TALKING
	self.current_with.current_state = Enums.ECharacterState.TALKING
			
			
	self.current_id = 0
	
	
	self.current_answers = dialogue_json.data['Talk'][current_id]['answers']
	
	self._on_actions(dialogue_json.data.keys())

	self.set_text_label(dialogue_json.data['Talk'][current_id]['text'])
	
	self.name_label.text = ' ' + with.npc_name + ' '
	
	self.visible = true
	self.ui_settings.close_for_dialogue()



func _on_dialogue_continue(_choice):
	
	var next_dialogue = dialogue_json.data['Talk'][current_id]['answers']
	print(next_dialogue)

	
func _remove_choise():
	for child in choices_array.get_children():
		child.queue_free()

func _on_actions(actions):
	
	
	for child in actions_array.get_children():
		child.queue_free()
		
		
	tween = self.find_child('tween')
	if tween:
		tween.kill()
	tween = self.create_tween()
	
	var last_position = Vector2(170, 270 + 16)
	var new_position =  Vector2(170, 270 + 16)
	var center_position = Vector2(104, 270)

	
	var _i = 2
	for one in actions:
		print(one)
		var choise = action_choice.instantiate()
		choise.visible = true
		choise.position = Vector2(104, 270)
		choise.get_child(0).visible = false
		choise.get_child(1).visible = true
		choise.get_child(0).text = one
		
		match one:
			'Fight' : 
				choise.get_child(1).icon = fight_choice_icon
				choise.get_child(0).visible = false
				new_position =  Vector2(center_position.x, center_position.y - 34)

			'Trade' : 
				choise.get_child(1).icon = trade_choice_icon
				choise.get_child(0).visible = false
				new_position = Vector2(center_position.x - 17, center_position.y - 17)
			'Talk' : 
				choise.get_child(1).icon = speak_choice_icon
				choise.get_child(0).visible = false
				new_position = Vector2(center_position.x + 17, center_position.y - 17)
		
		
		choise.get_child(1).text = ''
		choise.get_child(1).get_child(0).visible = false
		actions_array.add_child(choise)
		choise.get_child(1).connect("pressed", choice_clicked.bind(choise))
		choise.get_child(1).connect("mouse_entered", choice_hovered.bind(choise))
		tween.tween_property(choise, "position", new_position , 0.2).set_trans(Tween.TRANS_SINE)


		

func _on_talking_choices(choices):
	
	print(choices)

	self._remove_choise()
		
		
	tween = self.find_child('tween')
	if tween:
		tween.kill()
	tween = self.create_tween()
	
	var last_position = Vector2(170, 270 + 16)
	var new_position =  Vector2(170, 270 + 16)
	#var center_position = Vector2(104, 270)
	var center_position = Vector2(170, 270)
	
	last_position = center_position

	

	for one in choices:
		
		var choise = action_choice.instantiate()
		choise.position = center_position
		choise.get_child(1).icon = null
		choise.get_child(1).text = one
		
		choise.visible = true
		
		choise.get_child(1).visible = true
		choise.get_child(0).visible = false
		
		choise.get_child(1).size.y = 0
		#choise.get_child(0).get_child(0).visible = true
		new_position =  Vector2(last_position.x, last_position.y - 16)
		last_position = new_position
				
		choices_array.add_child(choise)
		tween.tween_property(choise, "position", new_position , 0.2).set_trans(Tween.TRANS_SINE)
		
		choise.get_child(1).connect("pressed", action_clicked.bind(choise))
		#choise.get_child(1).connect("mouse_entered", choice_hovered.bind(choise))
		
		#choise.position = new_position

func choice_clicked(choice):
	match choice.get_child(0).text:
		"Fight":
			self._on_dialogue_ended()
		"Trade":
			self._on_dialogue_ended()
		"Talk":
			print(current_answers)
			self._on_talking_choices(current_answers.keys())
			#self._on_dialogue_ended()

func action_clicked(choice):
	var next_dialogue = dialogue_json.data['Talk'][current_id]['answers'][choice.get_child(1).text]

	print(next_dialogue)

	if next_dialogue is float:
		print('int')	
		next_dialogue = int(next_dialogue)
		current_id = next_dialogue
		
		## NEED SEPARATE
		current_answers = dialogue_json.data['Talk'][current_id]['answers']
		self.set_text_label( dialogue_json.data['Talk'][current_id]['text'])
		
		
	elif next_dialogue is String:
		
		match next_dialogue:
			"Fight":
				self._on_dialogue_ended()
			"Trade":
				self._on_dialogue_ended()
			


func choice_hovered(choice):
	return 2

func _on_dialogue_ended():
	
	player.reset_state()
	current_with.reset_state()
	
	
	self.visible = false
