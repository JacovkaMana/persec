extends StaticBody2D

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
var starting_material
var created_by = null

@onready var interaction_hint = $InteractionHint
@onready var interaction_area = $InteractionArea
@onready var interaction_hint_player = $InteractionHint/AnimationPlayer
@onready var player = get_tree().get_root().find_child("Player", true, false)

@export var interactable: bool = true

@export var need_key: String

func get_collider_type():
	return 'Object'
	
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play('RESET')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func on_interact_area():
	if (interactable):
		interaction_hint_player.queue("float")
		interaction_hint.visible = true
	
func off_interact_area():
	if (interactable):
		interaction_hint_player.queue("RESET")
		interaction_hint.visible = false
	
func interact():
	print(player.data.inventory.has_key_item(need_key))
	if (interactable):
		if not need_key:
			self.open_door()
		elif player.data.inventory.has_key_item(need_key):
			self.open_door()
			
func open_door():
	anim.play('open_door')
	
	self.off_interact_area()
	interactable = false
