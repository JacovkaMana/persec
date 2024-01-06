extends Control

@onready var player = get_tree().get_root().find_child("Player", true, false)
@onready var tilemap: TileMap = get_tree().get_root().find_child("TileMap", true, false)
@onready var capture_viewport = get_tree().get_root().find_child("MapViewport", true, false)
@onready var rooms = get_tree().get_root().find_child("Rooms", true, false)
@onready var viewport_camera: Camera2D = capture_viewport.find_child('Camera')
@onready var player_marker = $PlayerMarker
@onready var player_line: Line2D = capture_viewport.find_child('PlayerLine')
@onready var custom_line = capture_viewport.find_child('CustomLine')
@onready var marker_object = preload("res://Scenes/Maps/player_marker.tscn")
@onready var display = $MinimapDisplay

var markers: Array = []
var minimap_scale = 0.1
var zoom_float = 8.0
var distance
var custom_line_count = 0
# Called when the node enters the scene tree for the first time.
func _ready():

	var tilemap_copy = tilemap.duplicate()
	capture_viewport.get_child(0).add_sibling(tilemap_copy)
	
#	tilemap_copy.visible = false
#	for room in rooms.get_children():
#		var new_mist = room.find_child('Mist')
#		new_mist.modulate = Color8(240,240,240)
#		capture_viewport.find_child('Zones').add_child(room.duplicate())

		
	display.texture.viewport_path = NodePath(capture_viewport.get_path())
	viewport_camera.zoom = Vector2((1.0 / zoom_float),(1.0 / zoom_float))
	#viewport_camera.global_position = player.global_position
	
	var interactables = get_tree().get_nodes_in_group("interactable")
	for object in interactables:
		var marker = marker_object.instantiate()
		distance = (object.global_position - player.global_position) / zoom_float
		#marker.position = Vector2(distance.x -32,distance.y -32)
		#marker.position = Vector2(object.position.x - 64, object.position.y - 64)
		marker.global_position = Vector2(object.global_position.x - 32 - 64, object.global_position.y - 32 - 64)
		marker.scale = Vector2(zoom_float, zoom_float) 
		marker.source_object = object
		marker.set_color()
		markers.append(marker)
		capture_viewport.add_child(marker)
	#print(interactables)
	
	var _timer = Timer.new()
	_timer.set_wait_time(0.25)
	_timer.set_one_shot(false)
	_timer.connect("timeout", _player_line)  
	add_child(_timer)
	_timer.start()

func _process(_delta):
	viewport_camera.global_position = player.global_position
	for marker in markers:
		if (is_instance_valid(marker)):
			if (is_instance_valid(marker.source_object)):
				marker.global_position = Vector2(marker.source_object.global_position.x - 32, marker.source_object.global_position.y - 32)
			else:
				marker.queue_free()

func _player_line():
	
	if (player_line.get_point_count() > 4):
		player_line.remove_point(0)
		
#	player_line.add_point(
#		Vector2(player.global_position.x, player.global_position.y)
#	)
	
	custom_line.get_child(custom_line_count).global_position = Vector2(player.global_position.x + 8, player.global_position.y + 8)
	custom_line_count = (custom_line_count + 1) % custom_line.get_child_count()
