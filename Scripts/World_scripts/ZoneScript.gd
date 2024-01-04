extends Area2D



@onready var player = get_tree().get_root().find_child("Player", true, false)
@onready var path_player : AnimationPlayer = $PathPlayer
@onready var path : Path2D = $Path2D
@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D
@onready var mist = $Mist
@onready var anim_player = $AnimationPlayer

var follow_position = Vector2(0,0)
var collision_shapes = []
var curr_obj
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", _on_enter) 
	
	for one in self.get_children():
		if one is CollisionShape2D:
			collision_shapes.append(one)
	#print(self.name)
	#path_player.set_root(Rooms/Second)
	#print(path_player.root_node)
	
	path_player.queue("path")

	if mist:
		self.mist.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	follow_position = path_follow.global_position



func _on_enter(what: Node2D):
	if what is Actor:
		what.set_zone(self)
		print(what, 'set zone', self)
	
	if what is PlayerScript:
		#self.mist.visible = false
		anim_player.queue("remove_mist")

