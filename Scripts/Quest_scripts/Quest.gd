class_name Quest
extends Resource

var name: String
var description : String
var difficulty: String
var completed: bool
var active: bool
var type: String

var target_type: String
var target_name : String
var target_count: int

var reward_type: String
var reward_name : String
var reward_count: int

var failure_type: String
var failure_name : String


var level: String
var location = null #Vector2(123.0, 234.1)

		
func _init(
	_name,
	_difficulty,
	_description, 
	_completed,
	_active,
	_type,
	_target_type,
	_target_name,
	_target_count,
	_reward_type,
	_reward_name,
	_reward_count,
	_failure_type,
	_failure_name,
	_level,
	_location,
	):
	self.name = _name
	self.difficulty = _difficulty
	
	self.description  = _description
	self.completed = _completed
	self.active = _active
	self.type = _type
	
	self.target_type = _target_type
	self.target_name = _target_name
	self.target_count = _target_count

	self.reward_type = _reward_type
	self.reward_name = _reward_name
	self.reward_count = _reward_count
	
	self.failure_type = _failure_type
	self.failure_name = _failure_name
	
	self.level = _level
	self.location = _location

