extends Node
var quests : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():

	var path = "res://Data/" + "Quests" + '.json'
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	for quest in json:
		var jquest = json[quest]
		
#		_description, 
#		_completed,
#		_active,
#		_type,
#		_target_type,
#		_target_name,
#		_target_count,
#		_level,
#		_location,
	
		quests[quest] = Quest.new(
		jquest['description'], 
		false,
		false,
		jquest['type'],
		jquest['target']['type'],
		jquest['target']['name'],
		jquest['target']['count'],
		jquest['location']['level'],
		jquest['location']['coords'],
			)
			
			
		print(json[quest])


