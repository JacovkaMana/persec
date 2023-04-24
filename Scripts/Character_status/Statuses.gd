extends Node2D


# Defending, Burning, Freezing, Bleeding, Stun,

@onready var Status_dict = {
	Enums.EStatus.DEFENDING : $Defending,
	Enums.EStatus.BURNING : $Burning
}

func _ready():
	for status in Status_dict.keys():
		hide_status(status)


func show_status(status: Enums.EStatus):
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
			
