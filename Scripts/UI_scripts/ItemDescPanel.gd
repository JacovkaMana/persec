extends Panel

@onready var start_position = self.position
@onready var drag_position = self.position
@onready var name_label = $NameLabel
@onready var desc_label = $Container/Description
@onready var stats_label = $Container/Stats
@onready var stats_separator = $Container/ISeparator
@onready var modifier_label = $Container/Modifier
@onready var item_icon = $ItemIcon
@onready var container: VBoxContainer = $Container
@onready var ending = $End
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("gui_input", _on_gui_input)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_item(item):
	name_label.text = item.name
	desc_label.text = item.description
	item_icon.texture = item.sprite
	modifier_label.text = ''
	if item.is_equipable():
		stats_label.visible = true
		modifier_label.visible = true
		stats_separator.visible = true
		stats_label.text = ''
		for stat in item.item_stats.keys():
				stats_label.text += stat + ' ' + str(item.item_stats[stat])
				stats_label.text += "\n"
		for modifier in item.modifiers:
				modifier_label.text += modifier.get_modifier_text() 
				modifier_label.text += "\n"
	else:
		stats_label.visible = false
		modifier_label.visible = false
		stats_separator.visible = false
	
#	for i in range(2):
#		container.visible = false
#		container.visible = true
#		container.visible = false
#		container.visible = true
	
	container.size.y = 1
	self.size.y = 34 + container.size.y
	ending.position.y = self.size.y - 25
	self.visible = true
func remove_item():
	self.visible = false
	#self.position = Vector2(-104,32)
	self.position = start_position

func _on_gui_input(event):
	#print('button down')
	#print(event)
	#print(event.is_pressed())
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == 1:
				on_left_click(event.position)
#			if event.button_index == 2:
#				print('Right_click press')
				
		#else:
			#if event.button_index == 1:
				#print('Left_click release')	
				#reset_position()
#			if event.button_index == 2:
#				print('Right_click release')
	
	if event.button_mask == 1:
		follow_cursor(event.position)
		#print(event)
		
func on_left_click(cursor):
	print(get_viewport().get_mouse_position(), "cursor")
	print(self.position, "position")
	drag_position = cursor
	

func follow_cursor(cursor):
	self.position += cursor - drag_position
	
	
func reset_position():
	self.position = drag_position
