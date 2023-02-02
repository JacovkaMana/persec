class_name AttackSkill
extends BaseSkill


@export var damage: int = 100
@export var multiplier: int = 1
@export var damage_type: Enums.EDamageType = Enums.EDamageType.STANDART


func get_damage_string():
	return (str(damage) + "%" + " x" + str(multiplier))

func get_damage():
	return damage
	
func get_multiplier():
	return multiplier
