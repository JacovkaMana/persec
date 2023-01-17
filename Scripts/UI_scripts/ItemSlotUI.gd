class_name ItemSlotUI
extends BaseSlotUI

signal slot_mouse_click(slot_index: BaseSlotUI)

@onready var equipped_icon: TextureRect = get_node("Content/IsEquippedTextureRect")
#@onready var following: bool = false
@onready var start_position = self.position

func _ready()->void:
	connect("gui_input", _on_gui_input)
	super._ready()


#func _process(delta):
#	if (following):
#		follow_cursor()

func _on_gui_input(event):
	#print('button down')
	#print(event)
	#print(event.is_pressed())
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == 1:
				on_left_click()
#			if event.button_index == 2:
#				print('Right_click press')
				
		else:
			if event.button_index == 1:
				#print('Left_click release')	
				reset_position()
#			if event.button_index == 2:
#				print('Right_click release')
	
	if event is InputEventMouseMotion and event.button_mask == 1:
		follow_cursor(event.position)
		#print(event)
		
func on_left_click():
	print("button leftclicked")
	start_position = self.position
	emit_signal("slot_mouse_click", self)

func follow_cursor(cursor):
	self.position += cursor - Vector2(11,11)
	
func reset_position():
	self.position = start_position
#
	
