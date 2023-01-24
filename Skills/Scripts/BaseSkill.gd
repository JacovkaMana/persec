class_name BaseSkill
extends Resource


@export var skill_name: String = "name"
@export var icon: Texture2D
@export var description: String = "description"
@export var count: int = 1

@export var effects: Array[Enums.EItemEffectType]

@export var weight: float = 0.0
@export var base_cost: float = 0.0
