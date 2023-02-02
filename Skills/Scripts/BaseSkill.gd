class_name BaseSkill
extends Resource


@export var name: String = "name"
@export var icon: Texture2D = preload("res://Art/Skills/test.png")
@export var description: String = "description"
@export var type: Enums.ESkillType = Enums.ESkillType.STANDARD 
@export var base_cost: float = 0.0
@export var effects: Array[Enums.EStatus] = null
@export var mastery: int = 0
@export var skills_needed: Array[BaseSkill] = []
@export var skills_learning: Array[BaseSkill] = []

func get_cost():
	return base_cost
