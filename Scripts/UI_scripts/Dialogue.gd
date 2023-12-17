extends Control

@onready var inventory_grid: GridContainer = $InventoryGrid
@onready var player = get_tree().get_root().find_child("Player", true, false)
@onready var desc_panel: Panel = $ItemDescPanel
@onready var actions_panel: Panel = get_tree().get_root().find_child("ItemActionsPanel", true, false)

@export var dialogue_choice = preload("res://Scenes/Objects/dialogue_choice.tscn")
@export var action_choice = preload("res://Scenes/Objects/action_choice.tscn")
@onready var choices_array = $Choices

var active_item_lclick: Item = null
var active_slot_rclick: BaseSlotUI = null
var panel_hover = false
var ItemButton = preload("res://Scenes/Inventory/ItemButton.tscn")
@onready var tween = self.create_tween()
var _item_inventory = null

@onready var ui_settings = $"../.."
@onready var hud_settings = $"../../HUD"
@onready var bground = $Background
@onready var shadow = $Shadow
@onready var name_label = $Label
@onready var text_label = $RichTextLabel
# !!!!! При закрытии закрывается ItemActionsPanel, если она над этой менюшкой!!!
# Called when the node enters the scene tree for the first time.

var dialogue_path = "res://Data/Dialogues/%s.json"
var dialogue_json = null
var current_id = null
var current_answers = null


var fight_choice_icon = preload("res://Art/UI/choice_fight.png")
var speak_choice_icon = preload("res://Art/UI/choice_speak.png")
var trade_choice_icon = preload("res://Art/UI/choice_trade.png")


func _ready():
	
	player.connect("dialogue_started", _on_dialogue)
	player.connect("dialogue_ended", _on_dialogue_ended)
	player.connect("dialogue_continue", _on_dialogue_continue)


func _on_dialogue(with):
	
	dialogue_json = load(dialogue_path % with)
	
	current_id = 0
	current_answers = dialogue_json.data['Talk'][current_id]['answers']
	self._on_choice(dialogue_json.data.keys(), current_answers.keys())
	ui_settings.close_for_dialogue()
	text_label.text = dialogue_json.data['Talk'][current_id]['text']
	name_label.text = ' ' + with + ' '
	self.visible = true
	#ui_settings.pause_game()
	
func _on_dialogue_continue(choice):
	
	var next_dialogue = dialogue_json.data['Talk'][current_id]['answers']
	print(next_dialogue)
	#name_label.text = ' ' + with + ' '
	#ui_settings.pause_game()
	
func _remove_choise():
	for one in choices_array:
		one.queue_free()

func _on_choice(actions, choices):
	if len(choices_array.get_children()) != 0:
		return 2
		
		
	var i = 1
	var tween = self.find_child('tween')
	if tween:
		tween.kill()
	tween = self.create_tween()
	
	var last_position = Vector2(170, 270 + 16)
	var new_position =  Vector2(170, 270 + 16)
	var center_position = Vector2(104, 270)

	
	var _i = 2
	for one in actions:
		var choise = action_choice.instantiate()
		choise.position = Vector2(104, 270)
		choise.get_child(0).text = one
		
		match one:
			'Fight' : 
				choise.get_child(1).texture = fight_choice_icon
				choise.get_child(0).visible = false
				new_position =  Vector2(center_position.x, center_position.y - 34)

			'Trade' : 
				choise.get_child(1).texture = trade_choice_icon
				choise.get_child(0).visible = false
				new_position = Vector2(center_position.x - 17, center_position.y - 17)
			'Talk' : 
				choise.get_child(1).texture = speak_choice_icon
				choise.get_child(0).visible = false
				new_position = Vector2(center_position.x + 17, center_position.y - 17)
				
		choices_array.add_child(choise)
		tween.tween_property(choise, "position", new_position , 0.2).set_trans(Tween.TRANS_SINE)

	for one in choices:
		
		var choise = dialogue_choice.instantiate()
		choise.position = Vector2(170, 270)
		choise.get_child(0).text = one
		choise.get_child(0).visible = true
		choise.get_child(0).get_child(0).visible = true
		new_position =  Vector2(last_position.x, last_position.y - 16)
		last_position = new_position
				
		choices_array.add_child(choise)
		tween.tween_property(choise, "position", new_position , 0.2).set_trans(Tween.TRANS_SINE)
		
#		if (i % 2) == 0:
#			new_position = Vector2(last_position.x - 17, last_position.y - 17)
#			choise.get_child(0).global_position.x = 145 + 17
#		else:
#			new_position =  Vector2(last_position.x + 17, last_position.y - 17)
#			choise.get_child(0).global_position.x = 145
			
#		tween.tween_property(choise, "position", new_position , 0.2).set_trans(Tween.TRANS_SINE)
#		last_position = new_position
#		i += 1

func _on_dialogue_ended():
	self.visible = false
