class_name PlayerData
extends Resource

signal stats_changed(stats: Dictionary)
signal status_changed()

@export var hitpoints: float = 100.0
@export var max_hitpoints: float = 100.0
@export var max_stamina: int = 4
@export var stamina_regen: float = 40
@export var money: int = 0

var statuses: Dictionary = {}
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
#func _ready():
#	print('ready from playerdata')

func _init():
	
	inventory.connect("equip_item_changed", recalculate_stats)
	recalculate_stats()
	#print('init from data')

func _process(_delta):
	pass



func recalculate_stats(_slot = null, _item = null):
	calculate_hp()
	calculate_modifiers()
	
	emit_signal("stats_changed", stats)
	
func calculate_hp():
	var cons = stats[Enums.EStat.CONSTITUTION]
	var flat = 0
	var perc = 0
	max_hitpoints = round( 
		((20*cons + 0.2*cons*cons) + flat) * (1 + perc / 100)
	)
	return max_hitpoints
	#print(max_hitpoints)

func calculate_damage_range():
	if (inventory.get_equipments_slot(Enums.EEquipmentSlot.R_HAND)):
		return inventory.get_equipments_slot(Enums.EEquipmentSlot.R_HAND).damage
	else:
		return stats[Enums.EStat.STRENGTH]
	
func calculate_crit_chance():
	if (inventory.get_equipments_slot(Enums.EEquipmentSlot.R_HAND)):
		return inventory.get_equipments_slot(Enums.EEquipmentSlot.R_HAND).crit_chance
	else:
		return stats[Enums.EStat.DEXTERITY]
	
func calculate_crit_damage():
	if (inventory.get_equipments_slot(Enums.EEquipmentSlot.R_HAND)):
		return inventory.get_equipments_slot(Enums.EEquipmentSlot.R_HAND).crit_damage
	else:
		return stats[Enums.EStat.DEXTERITY]
	
func calculate_defense():
	return 10
	
func calculate_evasion():
	return 6
	
func calculate_damage():
	return inventory.get_equipments_slot(Enums.EEquipmentSlot.R_HAND).get_flat_damage()
	
func calculate_modifiers():
	for item in inventory._equipment.values():
		if (item):
			for modifier in item.modifiers:
				pass
				#print( modifier.get_modifier_text() )

func stat_cost(stat: Enums.EStat):
	var s = stats[stat]
	var stat_a = 0.5
	var stat_b = 1
	return round(s*s * stat_a + s * stat_b)
	
func increase_stat(stat: Enums.EStat):
	var cost = stat_cost(stat)
	if (money >= cost):
		money -= cost
		stats[stat] += 1
		return true
	else:
		return false
		
	
func add_status(status: Enums.EStatus, duration: int):
	
	if self.statuses.has(status):
		self.statuses[status].queue_free()
		
	var status_timer = Timer.new()
	status_timer.set_wait_time(duration)
	status_timer.set_one_shot(true)
	status_timer.timeout.connect(remove_status.bind(status))  
	status_timer.start()
	self.statuses[status] = status_timer
	print(duration)
	
	#emit_signal("status_changed")
	return self.statuses[status]

	
func remove_status(status: Enums.EStatus):
	if self.statuses.has(status):
		statuses[status].queue_free()
		self.statuses.erase(status)
		
	#emit_signal("status_changed")
