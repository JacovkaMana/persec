extends VBoxContainer

@onready var player_data = get_tree().get_root().find_child("Player", true, false).data

@onready var stat_dict: Dictionary = {
	Enums.EStat.STRENGTH: $Stat1,
	Enums.EStat.DEXTERITY: $Stat2,
	Enums.EStat.CONSTITUTION: $Stat3,
	Enums.EStat.INTELLIGENCE: $Stat4,
	Enums.EStat.PERCEPTION: $Stat5,	
	Enums.EStat.CHARISMA: $Stat6,
}

func _ready():
	reload()
		
	if (stat_dict):
		for stat in stat_dict.keys():
			var button = stat_dict[stat].find_child('UpgradeStatButton')
			button.pressed.connect( _on_increase_stat_button.bind(
				button.stat_type
			))
		
func reload():
	if (stat_dict):
		for stat in stat_dict.keys():
			stat_dict[stat].find_child('StatAmountLabel').text = str(player_data.stats[stat])
			stat_dict[stat].find_child('StatUpCostLabel').text = str(player_data.stat_cost(stat))


func _on_increase_stat_button(stat: Enums.EStat):
	if (player_data.increase_stat(stat)):
		reload()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
