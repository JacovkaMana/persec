class_name PlayerData
extends Resource

@export var hitpoints: float = 100.0
@export var max_stamina: int = 4
@export var stamina_regen: float = 2
var stamina: float = 0.0
var inventory: Inventory = Inventory.new()
var skills: Skills = Skills.new()
var stats: Dictionary = {
	Enums.EStat.STRENGTH: null,
	Enums.EStat.DEXTERITY: null,
	Enums.EStat.CONSTITUTION: null,
	Enums.EStat.INTELLIGENCE: null,
	Enums.EStat.PERCEPTION: null,	
	Enums.EStat.CHARISMA: null,	
}
# Called when the node enters the scene tree for the first time.
func _ready():
	print('ready from playerdata')

func _init():
	print('init from playerdata')
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
