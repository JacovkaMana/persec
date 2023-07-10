extends Control

@onready var slider = $VSlider
@onready var container = $"../SkillContainer"
@onready var label = $Label
@onready var container_size = container.size
var container_pos: Vector2
var container_move: Vector2
var container_scale: int = 1
var starting: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	slider.connect("value_changed", on_zoom)
	container.pivot_offset = Vector2(320, 320)
	starting = container.position
	print(container.pivot_offset)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var signs = Vector2(sign(container.position.x), sign(container.position.y))
	#print(container.position + container_size * signs / 16 * (container_scale - 1))
	#print(container_size)
	pass


func on_zoom(value):
	print(value)
	print(container.position)
	print(container.pivot_offset)
#	container_pos = container.position
	container_move = (container.position + Vector2(320, 160)) / (value * 5) + Vector2(100,700)
	#print(container.position)
	container.pivot_offset = Vector2(320.0 - (container.position.x - starting.x) * 1, 320.0 - (container.position.y - starting.y) * 1) 
	container.scale = Vector2(value, value)
	container_scale = value
#	container.position = container_pos * value
#
#	if value > container_scale:
#		container.position = container_pos * value
#	else:
#		container.position = container_pos / value
#
##	if value > container_scale:
##		container.position.x = container_pos.x - container_size.x / 2.0
##		container.position.y = container_pos.y - container_size.y / 2.0
##	else:
##		container.position.x = container_pos.x + container_size.x / 2.0
##		container.position.y = container_pos.y + container_size.y / 2.0
#
#	container_scale = value
	label.text = "x" + str(value)
