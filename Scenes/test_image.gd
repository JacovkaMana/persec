extends TextureRect

var atlas: Texture2D = preload("res://Art/Textures/SwordMap.png")
@export var sprite: Texture2D
# Called when the node enters the scene tree for the first time.
func _ready():
	self.texture = sprite.draw_rect(self, Rect2(0,0,22,22), false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
