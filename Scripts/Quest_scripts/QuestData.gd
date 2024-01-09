class_name QuestData
extends Resource

var _quests : Array[Quest]


func _init():
		
	self._quests = []


func new_quest(quest_name: String):
	if quest_name in GlobalQuests.quests.keys():
		
		var new_quest = GlobalQuests.quests[quest_name]
		
		if new_quest not in self._quests:
			self._quests.append(new_quest)
			print(self._quests)
			return new_quest
			
		return null
		
	return null

func get_quests() -> Array[Quest]:
	return _quests
