extends Sprite2D

var start_pos: Vector2
var moving: bool = false
var direction: Vector2

@export var move_speed : float = 30 
@export var range: float
# Called when the node enters the scene tree for the first time.
func _ready():
	
	start_pos = self.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (moving):
		position += direction * delta * move_speed
	
func shoot(where: Vector2, speed:= 30):
	moving = true
	direction = where
	move_speed = speed
