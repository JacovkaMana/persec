extends Panel

@onready var start_position = self.position
@onready var drag_position = self.position
@onready var name_label = $NameLabel
@onready var desc_label = $Container/Description
@onready var modifier_label = $Container/Modifier
@onready var item_icon = $ItemIcon

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
		for modifier in item.modifiers:
				modifier_label.text += modifier.get_modifier_text() 
				modifier_label.text += "\n"
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
