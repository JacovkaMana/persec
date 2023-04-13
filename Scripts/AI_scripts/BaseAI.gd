extends Resource
class_name BaseAI


var owner: Actor = null
var target: Actor = null
var active: bool = false

func setup(_owner, _target):
	self.owner = _owner
	self.target = _target
	active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
