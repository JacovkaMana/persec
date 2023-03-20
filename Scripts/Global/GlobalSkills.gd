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
	
#	var path = "res://Data/" + self.npc_name + '.json'
#	var file = FileAccess.open(path, FileAccess.READ)
#	var dialogue: Dictionary = JSON.parse_string(file.get_as_text())



	skills['Slash'] = AttackSkill.new(
		'Slash',
		1,
		Enums.EDamageType.SLASH,
		Enums.ESkillType.BLADE,
		load("res://PreRendered/Projectiles/Slash.tscn"),
	)
	
	skills['Fireball'] = AttackSkill.new(
		'Fireball',
		1,
		Enums.EDamageType.FIRE,
		Enums.ESkillType.MAGIC,
		load("res://PreRendered/Projectiles/Ball.tscn"),
		
	)
	
	skills['Ice Slash'] = AttackSkill.new(
		'Ice Slash',
		2,
		Enums.EDamageType.ICE,
		Enums.ESkillType.MAGIC,
		load("res://PreRendered/Projectiles/MovingSlash.tscn"),
	)
