extends Control


@onready var bg = $Bg
@onready var container = $HBoxContainer
var tween
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func reload():
	
	container.visible = false
	container.visible = true
	container.visible = false
	container.visible = true
	
	bg.size.x = container.size.x + 32
	self.size.x = container.size.x + 32
	print(self.size.x)


func fade():
	
	if tween:
		tween.kill() # Abort the previous animation.
	tween = create_tween()
	tween.tween_property(self, "modulate", Color8(255,255,255,0), 3)
	tween.finished.connect(delete)
	
func delete():
	self.queue_free()
