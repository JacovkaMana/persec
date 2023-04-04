class_name AttackSkill
extends BaseSkill


var ranged_damage: int
var melee_damage: int
var melee_attacks: int 
var multiplier: int
@export var damage_type: Enums.EDamageType = Enums.EDamageType.NONE

func _init(name: String, description: String, ranged_damage: int, melee_damage: int, multiplier:int,  stamina_cost: int ,damage_type: Enums.EDamageType, type: Enums.ESkillType, projectile, skill_icon):

		self.name = name
		self.description = description
		self.ranged_damage = ranged_damage
		self.melee_damage = melee_damage
		self.multiplier = multiplier
		self.damage_type = damage_type
		self.type = type
		self.projectile = projectile
		self.cost = stamina_cost
		self.icon =GlobalSprites.skill_icons[skill_icon]

func get_ranged_damage_string():
	return (str(ranged_damage) + "%" + " x" + str(multiplier))

func get_ranged_damage():
	return ranged_damage
	
func get_multiplier():
	return multiplier
