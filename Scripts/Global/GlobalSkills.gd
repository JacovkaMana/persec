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

func _init():
	
	var path = "res://Data/" + "Skills" + '.json'
	var file = FileAccess.open(path, FileAccess.READ)
	var dialogue: Dictionary = JSON.parse_string(file.get_as_text())
	for skill in dialogue:
		skills[skill] = AttackSkill.new(
		skill,
		dialogue[skill].cost,
		Enums.EDamageType.get( dialogue[skill].damage_type ),
		Enums.ESkillType.get( dialogue[skill].skill_type ),
		load("res://PreRendered/Projectiles/" + dialogue[skill].texture + ".tscn"),
	)


