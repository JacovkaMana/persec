class_name ViewerManager
extends Resource


var viewers: Array[Viewer] = []

var viewer_types = {
	'Jerk' : [Enums.EViewerAction.FIGHT, Enums.EViewerAction.SLAY, Enums.EViewerAction.BETRAY],
	
}

func _init():
		self.add_viewer()
		self.add_viewer()

func add_viewer(include_type = null):
	var new_type
	if include_type:
		for one in viewer_types.keys():
			if include_type in viewer_types[one]:
				new_type = one
	else:
				new_type = viewer_types.keys().pick_random()
				
	var new = Viewer.new(
		new_type,
		viewer_types[new_type]	
	)
	viewers.append(new)

func action_to_viewers(action: Enums.EViewerAction, value: int):
	for i in viewers.size():
		if action in viewers[i].loves:
			match viewers[i].add_satisfaction(value):
				'Min': viewers.erase(viewers[i])
				'Max': add_viewer(viewers[i].loves.pick_random())
				
func get_overall_satisfaction():
	var sum = 0
	for one in viewers:
		sum += one.satisfaction
	return sum / viewers.size()
	
	


