class_name Modifier
extends Resource

@export var level: int = 0
@export var type: Enums.EModifierType = Enums.EModifierType.NONE
@export var subtype: Enums.EModifierSubtype = Enums.EModifierSubtype.NONE
@export var value: int = 0
var text: String = ''

func _init(random: bool = true):
	
	if (random):
		
		self.type = Enums.EModifierType.get(
			Enums.EModifierType.keys()[1 + randi() % (Enums.EModifierType.size() - 1)]
		)
		
		self.subtype = Enums.EModifierSubtype.get(
			Enums.EModifierSubtype.keys()[1 + randi() % (Enums.EModifierSubtype.size() - 1)]
		)
		
		if (type == Enums.EModifierType.Percent):
			self.value = randi_range(0,100)
			self.text = str(self.value) + '% Increased ' + str(Enums.EModifierSubtype.keys()[self.subtype])
		
		if (type == Enums.EModifierType.Flat):
			self.value = randi_range(0,15)
			self.text = 'ADDS' + str(self.value) + str(Enums.EModifierSubtype.keys()[self.subtype])
			
		if (type == Enums.EModifierType.Ability):
			self.value = 0
			self.text = 'Ability text'
		
	

	
func get_modifier_type():
	return self.type

func get_modifier_text():
	return self.text
