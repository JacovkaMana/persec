class_name AttackSkill
extends BaseSkill


@export var damage: int = 100
@export var multiplier: int = 1
@export var damage_type: Enums.EDamageType = Enums.EDamageType.NONE

func _init(name: String, stamina_cost: int ,damage_type: Enums.EDamageType, type: Enums.ESkillType, projectile):

		self.name = name
		self.damage_type = damage_type
		self.type = type
		self.projectile = projectile
		self.cost = stamina_cost
		
func get_damage_string():
	return (str(damage) + "%" + " x" + str(multiplier))

func get_damage():
	return damage
	
func get_multiplier():
	return multiplier
