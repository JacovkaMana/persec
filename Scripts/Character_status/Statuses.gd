extends Node2D


# Defending, Burning, Freezing, Bleeding, Stun,

@onready var Status_dict = {
	Enums.EStatus.DEFEND : $Defend,
	Enums.EStatus.SHIELD : $Shield,
	Enums.EStatus.BURN : $Burn,
	Enums.EStatus.FIRE_WEAPON : $Armament
}

func _ready():
	for status in Status_dict.keys():
		hide_status(status)


func show_status(status: Enums.EStatus):
	#print(Enums.EStatus.find_key(status))
	if (Status_dict[status]):
		Status_dict[status].visible = true
		match Status_dict[status].get_class():
			'Area2D': 
				Status_dict[status].intercept = true
		
func hide_status(status: Enums.EStatus):
	if (Status_dict[status]):
		Status_dict[status].visible = false
		match Status_dict[status].get_class():
			'Area2D': 
				Status_dict[status].intercept = false
			
func shield(_skill, _status, _duration, _shield):
	Status_dict[Enums.EStatus.SHIELD].visible = true
	Status_dict[Enums.EStatus.SHIELD].intercept = true
	Status_dict[Enums.EStatus.SHIELD].shield = _shield
	
	
