class_name PlayerData
extends Resource

@export var hitpoints: float = 100.0
@export var max_hitpoints: float = 100.0
@export var max_stamina: int = 4
@export var stamina_regen: float = 40
@export var money: int = 0
var stamina: float = 0.0
var inventory: Inventory = Inventory.new()
var skills: Skills = Skills.new()
var stats: Dictionary = {
	Enums.EStat.STRENGTH: 5,
	Enums.EStat.DEXTERITY: 5,
	Enums.EStat.CONSTITUTION: 5,
	Enums.EStat.INTELLIGENCE: 5,
	Enums.EStat.PERCEPTION: 5,	
	Enums.EStat.CHARISMA: 5,	
}
# Called when the node enters the scene tree for the first time.
func _ready():
	print('ready from playerdata')

func _init():
	recalculate_stats()
	print('init from playerdata')
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func recalculate_stats():
	calculate_hp()
	
func calculate_hp():
	var cons = stats[Enums.EStat.CONSTITUTION]
	var flat = 0
	var perc = 0
	max_hitpoints = round( 
		((20*cons + 0.2*cons*cons) + flat) * (1 + perc / 100)
	)
	print(max_hitpoints)
	
