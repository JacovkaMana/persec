class_name PlayerData
extends Resource

var hitpoints: float = 100.0
var inventory: Inventory = Inventory.new()
var skills: Skills = Skills.new()
var stats: Dictionary = {
	Enums.EStat.STRENGTH: null,
	Enums.EStat.DEXTERITY: null,
	Enums.EStat.CONSTITUTION: null,
	Enums.EStat.INTELLIGENCE: null,
	Enums.EStat.PERCEPTION: null,	
}
# Called when the node enters the scene tree for the first time.
func _ready():
	print('ready from playerdata')

func _init():
	print('init from playerdata')
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
