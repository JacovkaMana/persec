extends CanvasLayer

@export var ShadowColor: Color = Color(0,0,0)
@export var BackgroundColor: Color = Color(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	var bg_children = find_children("Background", "TextureRect", true, false)
	#var Background_children = self.find_children("Background", "TextureRect", true, false)
	print('bg children')
	print(bg_children)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

