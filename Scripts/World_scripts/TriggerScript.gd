extends Area2D

@onready var player: PlayerScript = get_tree().get_root().find_child("Player", true, false)
@onready var path_player : AnimationPlayer = $PathPlayer
@onready var path : Path2D = $Path2D
@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D
@onready var mist = $Mist
@onready var anim_player = $AnimationPlayer

@export var enabled = false

@export var quest = ''
@export var dialogue = ''
#@export var quest = null
#@export var quest = null

var follow_position = Vector2(0,0)
var collision_shapes = []
var curr_obj
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", _on_enter) 
	
func _on_enter(what: Node2D):

	if what is PlayerScript and enabled:
		if quest:
			player.add_quest(quest)
