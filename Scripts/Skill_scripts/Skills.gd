class_name Skills
extends Resource


var _skills: Array[BaseSkill]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func get_skills():
	return _skills

func get_skill_id(id: int):
	return _skills[id]

func get_skill_name(_name: String):
	return 'test'
	
func add_skill(skill: BaseSkill):
	_skills.append(skill)
	return true

func remove_skill(skill: BaseSkill):
	if (skill in _skills):
		_skills.pop_at(_skills.find(skill))
		return true
	return false
