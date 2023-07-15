#class_name BaseSkill
#extends Resource
#
#
#var name: String
#var icon  #: Texture2D = preload("res://Art/Icons/Skills/single_29.png")
#var projectile   #: Texture2D = preload("res://Art/Masks/test_mask.png")
#var description: String 
#var type: Enums.ESkillType = Enums.ESkillType.NONE
#var cost: int
#var effects: Array[Enums.EStatus] = []
#var mastery: int
#
#
#var damage: int
#var multiplier: int
##var moving_projectile : bool
#
#
#var skills_needed: Array[BaseSkill] = []
#var skills_learning: Array[BaseSkill] = []
#
#@export var damage_type: Enums.EDamageType = Enums.EDamageType.NONE
#
#
#func _init(name: String, description: String, rarity = null):
#
#	if(name):
#		self.name = name
#
#	if(description):
#		self.description = description
#
#	if(rarity):
#		self.rarity = rarity
#
#
#func get_cost():
#	return cost
#
#func get_skill_sprite():
#	return projectile
#
#
#func get_skill_type():
#	return ''
