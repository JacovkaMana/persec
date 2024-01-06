extends Area2D
class_name ZoneScript


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
	
	if path_player:
		path_player.queue("path")

	if mist:
		self.mist.visible = true



func get_random_pos():
	print(self.collision_shapes)
	var shape = self.collision_shapes.pick_random()
	var shape_area = shape.shape.extents
	var shape_origin = shape.global_position - shape_area
	print(shape_area, shape_origin)

	#var x = randi_range(min(shape_origin.x, shape_area.x), max(shape_origin.x, shape_area.x) )
	#var y = randi_range(min(shape_origin.y, shape_area.y), max(shape_origin.y, shape_area.y) )
	var x = randi_range(shape.global_position.x - shape.shape.size.x / 2, shape.global_position.x + shape.shape.size.x / 2)
	var y = randi_range(shape.global_position.y - shape.shape.size.y / 2, shape.global_position.y + shape.shape.size.y / 2)
	print(Vector2(x, y))
	print(shape.shape.get_rect())
	return Vector2(x, y)
	

func _physics_process(_delta):
	if path_follow:
		follow_position = path_follow.global_position



func _on_enter(what: Node2D):
	if what is Actor:
		what.set_zone(self)
		print(what, 'set zone', self)
	
	if what is PlayerScript:
		#self.mist.visible = false
		if self.mist.visible:
			anim_player.queue("remove_mist")

