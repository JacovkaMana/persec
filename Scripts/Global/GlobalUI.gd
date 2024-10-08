extends CanvasLayer

@export var ShadowColor: Color = Color(0,0,0)
@export var BackgroundColor: Color = Color(0,0,0)

@onready var Character_UI = $UI/Character
@onready var Inventory_UI = $UI/Inventory
@onready var Menu_UI = $PauseMenu
@onready var Menu_Content = $PauseMenu/MenuContent
@onready var Menu_Animation = $PauseMenu/AnimationPlayer
@onready var DroppedItems_UI = $UI/DroppedItems
@onready var SoundBar = $HUD/SoundBar
@onready var UI_Control = $UI
@onready var HUD_Control = $HUD
@onready var SceneManager = self.get_tree().get_root().find_child("SceneManager", true, false)
@onready var player: PlayerScript = get_tree().get_root().find_child("Player", true, false)
# Called when the node enters the scene tree for the first time.
func _ready():
	InputManager.UI_Global = self
	self.close_everything()
	var _bg_children = find_children("Background", "TextureRect", true, false)
	#var Background_children = self.find_children("Background", "TextureRect", true, false)
	player.connect("dialogue_started", dialogue_start)
	player.connect("dialogue_ended", show_hud)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func close_everything():
	DroppedItems_UI.visible = false
	Inventory_UI.visible = false
	Character_UI.visible = false

func close_for_dialogue():
	DroppedItems_UI.visible = false
	Inventory_UI.visible = false
	Character_UI.visible = false
	HUD_Control.close_lower()	
	
func hide_hud():
	HUD_Control.visible = false
	
func dialogue_start(_with, _text):
	self.hide_hud()

func show_hud():
	HUD_Control.visible = true
	
func pause_game():
	self.get_parent().pause_game()

func character_switch():
	if Character_UI.visible:
		Character_UI.visible = false
	else:
		Character_UI.visible = true	

func inventory_switch():
	if Inventory_UI.visible:
		Inventory_UI.visible = false
	else:
		Inventory_UI.visible = true	
		
		
func menu_switch():
	if Menu_UI.visible:
		Menu_Content.visible = false
		Menu_Animation.play_backwards("menu_startup")
		await Menu_Animation.animation_finished
		Menu_UI.visible = false
		SceneManager.unpause_game()
	else:
		# Тут ещё паузу надо вставить
		SceneManager.pause_game()
		Menu_Animation.seek(1, true)
		Menu_UI.visible = true
		#Menu_Animation.play("menu_startup")
		#await Menu_Animation.animation_finished
		Menu_Content.visible = true
		
		
func dropped_switch():
	if DroppedItems_UI.visible:
		DroppedItems_UI.visible = false
	
