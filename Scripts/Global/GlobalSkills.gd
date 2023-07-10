extends Node
var skills : Array[AttackSkill]

var shaders = {
	Enums.EDamageType.EARTH : preload("res://Art/Shaders/EarthShader.tres"),
	Enums.EDamageType.ICE : preload("res://Art/Shaders/IceShader.tres"),
	Enums.EDamageType.THUNDER: preload("res://Art/Shaders/ThunderShader.tres"),
	Enums.EDamageType.WATER : preload("res://Art/Shaders/WaterShader.tres"),
	Enums.EDamageType.WIND : preload("res://Art/Shaders/WindShader.tres"),
	Enums.EDamageType.FIRE : preload("res://Art/Shaders/SkillShader.tres"),
}

var colors = {
	Enums.EDamageType.EARTH : preload("res://Art/Colors/Fire.tres"),
	Enums.EDamageType.ICE : preload("res://Art/Colors/Ice.tres"),
	Enums.EDamageType.THUNDER: preload("res://Art/Colors/Fire.tres"),
	Enums.EDamageType.WATER : preload("res://Art/Colors/Fire.tres"),
	Enums.EDamageType.WIND : preload("res://Art/Colors/Fire.tres"),
	Enums.EDamageType.FIRE : preload("res://Art/Colors/Fire.tres"),
}

func _ready():
	var path = "res://Data/" + "Skills" + '.json'
	var file = FileAccess.open(path, FileAccess.READ)
	var skill_list: Array = JSON.parse_string(file.get_as_text())
	for skill in skill_list:
		match skill.type:
			'attack':
				skills.append(AttackSkill.new(
				skill.name,
				skill.description,
				skill.damage.ranged,
				skill.moving,
				skill.damage.melee,
				skill.damage.multiplier,
				skill.cost,
				Enums.EDamageType.get( skill.damage_type ),
				Enums.ESkillType.get( skill.skill_type ),
				load("res://PreRendered/Projectiles/" + skill.texture + ".tscn"),
				skill.icon
				)) 
			'status':
				skills.append(StatusSkill.new(
				skill.name,
				skill.description,
				Enums.EStatus.get( skill.status["self"] ),
				Enums.EStatus.get( skill.status.enemy ),
				skill.status.duration,
				skill.cost,
				Enums.EDamageType.get( skill.damage_type ),
				Enums.ESkillType.get( skill.skill_type ),
				load("res://PreRendered/Projectiles/" + skill.texture + ".tscn"),
				skill.icon
			))

