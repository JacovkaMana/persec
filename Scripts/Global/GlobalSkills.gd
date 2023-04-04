extends Node

var skills = {
	
}

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
	var dialogue: Dictionary = JSON.parse_string(file.get_as_text())
	for skill in dialogue:
		var skill_json = dialogue[skill]
		if skill_json.type == 'attack':
			skills[skill] = AttackSkill.new(
			skill,
			skill_json.description,
			skill_json.ranged_damage,
			skill_json.melee_damage,
			skill_json.multiplier,
			skill_json.cost,
			Enums.EDamageType.get( skill_json.damage_type ),
			Enums.ESkillType.get( skill_json.skill_type ),
			load("res://PreRendered/Projectiles/" + skill_json.texture + ".tscn"),
			skill_json.icon
		)


