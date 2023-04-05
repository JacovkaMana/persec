class_name StatusSkill
extends BaseSkill

var self_status: Enums.EStatus
var enemy_status: Enums.EStatus
var status_duration: int = 2

@export var damage_type: Enums.EDamageType = Enums.EDamageType.NONE


func _init(name: String, description: String, self_status: Enums.EStatus, enemy_status: Enums.EStatus, duration:int,  stamina_cost: int ,damage_type: Enums.EDamageType, type: Enums.ESkillType, projectile, skill_icon):

		self.name = name
		self.description = description
		self.self_status = self_status
		self.enemy_status = enemy_status
		self.status_duration = duration
		self.damage_type = damage_type
		self.type = type
		self.projectile = projectile
		self.cost = stamina_cost
		self.icon = GlobalSprites.skill_icons[skill_icon]

func get_skill_type():
	return 'Status'
