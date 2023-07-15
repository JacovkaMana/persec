extends Node
var skills : Array[Skill]

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
	var json = JSON.parse_string(file.get_as_text())
	for type in json:
		
			print('Type (Tree) - ' + type)
			print('\n')
			
			for json_down in json[type]:
				for subtype in json_down:
					
					print('Subtype (Branch) - ' + subtype)
					print('\n')
					
					for skill_dict in json_down[subtype]:
						for skill in skill_dict:
							
							print(skill)
							print(skill_dict[skill]['description'])
							print('\n')
					
				#subtype = JSON.parse_string(subtype)
				#print(subtype)
							var new = Skill.new(
								Enums.ESkillType.get(type.to_upper()),
								Enums.ESkillSubtype.get('NONE'),
								skill,
								skill_dict[skill]['description'],
								skill_dict[skill]['cost'],
								skill_dict[skill]['compatible'],
								skill_dict[skill]['texture'],
								skill_dict[skill]['icon'],
								skill_dict[skill]['locked'],
								skill_dict[skill]['requires'],
								)
							self.skills.append(new)
							print(var_to_bytes(new))
							print(self.skills)

#			Enums.ESkillType.get( tree),
#			Enums.ESkillType.get( NONE),
#			skill.name,
#			skill.description,
#			skill.damage.ranged,
#			skill.moving,
#			skill.damage.melee,
#			skill.damage.multiplier,
#			skill.cost,
#			Enums.EDamageType.get( skill.damage_type ),
#			Enums.ESkillType.get( skill.skill_type ),
#			load("res://PreRendered/Projectiles/" + skill.texture + ".tscn"),
#			skill.icon
#			)
#
#			print(var_to_bytes(new))
#
		


