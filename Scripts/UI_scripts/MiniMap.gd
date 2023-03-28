extends Sprite2D

@onready var player = get_tree().get_root().find_child("Player", true, false)
@onready var tilemap: TileMap = get_tree().get_root().find_child("TileMap", true, false)
@onready var capture_viewport = get_tree().get_root().find_child("CaptureViewport", true, false)
@onready var viewport_camera: Camera2D = capture_viewport.find_child('Camera')
@onready var player_marker: Sprite2D = capture_viewport.find_child('PlayerMarker')
@onready var marker_object = preload("res://Scenes/Maps/player_marker.tscn")
@onready var display = $MinimapDisplay

var markers: Array = []
var minimap_scale = 0.1
var zoom_float = 8.0
var distance
# Called when the node enters the scene tree for the first time.
func _ready():

	var tilemap_copy = tilemap.duplicate()
	capture_viewport.get_child(0).add_sibling(tilemap_copy)
	display.texture.viewport_path = NodePath(capture_viewport.get_path())
	viewport_camera.zoom = Vector2((1.0 / zoom_float),(1.0 / zoom_float))
	viewport_camera.global_position = player.global_position
	
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
	
func _process(delta):
	viewport_camera.global_position = player.global_position


