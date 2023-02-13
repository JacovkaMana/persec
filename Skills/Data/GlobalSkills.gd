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
	
	skills['Slash'] = AttackSkill.new()
	skills['Slash'].name = 'Slash'
	skills['Slash'].damage_type = Enums.EDamageType.SLASH
	skills['Slash'].type = Enums.ESkillType.BLADE
	
	skills['Fireball'] = AttackSkill.new()
	skills['Fireball'].name = 'Fireball'
	skills['Fireball'].damage_type = Enums.EDamageType.FIRE
	skills['Fireball'].type = Enums.ESkillType.MAGIC
	skills['Fireball'].projectile = preload("res://Art/Masks/Ball.png")
	
	skills['Ice Slash'] = AttackSkill.new()
	skills['Ice Slash'].name = 'Ice Slash'
	skills['Ice Slash'].type = Enums.ESkillType.MAGIC
	skills['Ice Slash'].damage_type = Enums.EDamageType.ICE
