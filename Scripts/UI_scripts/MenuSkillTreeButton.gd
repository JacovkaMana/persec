extends TextureButton

@export var SkillName: String
@onready var SkillDescription = $"../../../../SkillDescription/SkillName"
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", change_description)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func change_description():
	print("122121")
	SkillDescription.text = SkillName
