extends CanvasLayer

@export var ShadowColor: Color = Color(0,0,0)
@export var BackgroundColor: Color = Color(0,0,0)

@onready var Character_UI = $UI/Character
@onready var Inventory_UI = $UI/Inventory
@onready var DroppedItems_UI = $UI/DroppedItems
@onready var UI_Control = $UI
# Called when the node enters the scene tree for the first time.
func _ready():
	InputManager.UI_Global = self
	
	var bg_children = find_children("Background", "TextureRect", true, false)
	#var Background_children = self.find_children("Background", "TextureRect", true, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func close_everything():
	DroppedItems_UI.visible = false
	Inventory_UI.visible = false
	Character_UI.visible = false

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
		
func dropped_switch():
	if DroppedItems_UI.visible:
		DroppedItems_UI.visible = false
	
