extends Path2D
@onready var follow = $LineFollow
@onready var follow_2 = $LineFollow2
@onready var follow_3 = $LineFollow3
@onready var texture = $LineTexture
@onready var texture_2 = $LineTexture2
@onready var texture_3 = $LineTexture3
var speed = 0.010

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	follow.progress_ratio += speed
	follow_2.progress_ratio += speed
	follow_3.progress_ratio += speed
	texture.position = follow.position
	texture_2.position = follow_2.position
	texture_3.position = follow_3.position


func initiate(stage: int):
	follow.progress_ratio = float(stage) / 10.0
	follow_2.progress_ratio = follow.progress_ratio + 0.33
	follow_3.progress_ratio = follow.progress_ratio + 0.66
