extends Node
var quests : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():

	var path = "res://Data/" + "Quests" + '.json'
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	for quest in json:
		var jquest = json[quest]
		
		quests[quest] = Quest.new(
		quest,
		jquest['difficulty'], 
		jquest['description'], 
		false,
		false,
		jquest['type'],
		jquest['target']['type'],
		jquest['target']['name'],
		jquest['target']['count'],
		jquest['reward']['type'],
		jquest['reward']['name'],
		jquest['reward']['count'],
		jquest['failure']['type'],
		jquest['failure']['name'],
		jquest['location']['level'],
		jquest['location']['coords'],
			)
			
			
		print(json[quest])


