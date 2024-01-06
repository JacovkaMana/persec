class_name Skill
extends Resource

	
var type: Enums.ESkillType = Enums.ESkillType.NONE
var subtype: Enums.ESkillSubtype = Enums.ESkillSubtype.NONE


var name: String
var description: String 

var icon  #: Texture2D = preload("res://Art/Icons/Skills/single_29.png")
var projectile   #: Texture2D = preload("res://Art/Masks/test_mask.png")
var texture   #: Texture2D = preload("res://Art/Masks/test_mask.png")
	

var cost: int
var compatible: Array
var skills_requires: Array[Skill] = []
var skills_unlocks: Array[Skill] = []
var locked: bool
var requires : Array #temp string 

var mastery: int

var is_damage_skill: bool = false
var damage_value: int
var damage_count: int
var damage_type: Enums.EDamageType

var is_status_skill: bool = false
var status_self: Array[Enums.EStatus] = []
var status_enemy: Array[Enums.EStatus] = []
var status_duration: int




func _init(
	_type: Enums.ESkillType,
	_subtype: Enums.ESkillSubtype,
	_name: String, 
	_description: String,
	_cost: int,
	_compatible: Array,
	_texture,
	_icon,
	_locked: bool,
	_requires: Array,
	):
		self.type = _type
		self.subtype = _subtype
		self.name = _name
		self.description = _description
		self.cost = _cost
		self.compatible = _compatible
		self.projectile = load("res://PreRendered/Projectiles/" + _texture + ".tscn")
		#self.icon = GlobalSprites.skill_icons[icon]
		self.icon =  load("res://Art/Icons/Skills/" + _icon + ".png")
		self.locked = _locked
		self.requires = _requires
		

func get_damage_string():
	if (self.is_damage_skill):
		return (str(damage_value) + "%" + " x" + str(damage_value))
	else:
		return null

func get_cost():
	return self.cost
