class_name Quest
extends Resource


var description : String
var completed: bool
var active: bool
var type: String
var target_type: String
var target_name : String
var target_count: int

var level: String
var location = null #Vector2(123.0, 234.1)

		
func _init(
	_description, 
	_completed,
	_active,
	_type,
	_target_type,
	_target_name,
	_target_count,
	_level,
	_location,
	):
		
	self.description  = _description
	self.completed = _completed
	self.active = _active
	self.type = _type
	self.target_type = _target_type
	self.target_name = _target_name
	self.target_count = _target_count

	self.level = _level
	self.location = _location

