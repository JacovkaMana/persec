class_name Viewer
extends Resource


var type: String
var loves
var satisfaction: float

var min_satisfaction = 0
var max_satisfaction = 100

func _init(type: String, loves):
		self.type = type
		self.loves = loves
		self.satisfaction = 50
		
func add_satisfaction(power):
	if self.satisfaction + power >= 100:
		self.satisfaction = 100
		return 'Max'
	elif self.satisfaction + power <= 0:
		self.satisfaction = 0
		return 'Min'
	
	self.satisfaction = self.satisfaction + power
	return str(self.satisfaction)
	


