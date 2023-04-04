class_name BaseSkill
extends Resource


@export var name: String = "name"
#@export var icon: Texture2D = preload("res://Art/Skills/test.png")
@export var icon = preload("res://Art/Icons/Skills/single_29.png")
#@export var projectile: Texture2D = preload("res://Art/Masks/test_mask.png")
@export var description: String = "description"
@export var type: Enums.ESkillType = Enums.ESkillType.NONE
@export var cost: float = 0.0
@export var effects: Array[Enums.EStatus] = []
@export var mastery: int = 0
@export var skills_needed: Array[BaseSkill] = []
@export var skills_learning: Array[BaseSkill] = []

var projectile = null

func _init(name: String, description: String, rarity = null):

	if(name):
		self.name = name

	if(description):
		self.description = description

	if(rarity):
		self.rarity = rarity
	
	
func get_cost():
	return cost
	
func get_skill_sprite():
	return projectile
