extends Control

@onready var Character_UI = $Character
@onready var Inventory_UI = $Inventory
@onready var DroppedItems_UI = $DroppedItems


func _ready():
	pass # Replace with fuction body.



		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print(get_viewport())
	pass


func _on_item_container_mouse_entered():
	pass # Replace with function body.
#
#
#func _on_menu_closed(menu_name: String):
#	self.find_child(menu_name).visible = false

#func character_switch():
#	if Character_UI.visible:
#		Character_UI.visible = false
#	else:
#		Character_UI.visible = true	
#
#func inventory_switch():
#	if Inventory_UI.visible:
#		Inventory_UI.visible = false
#	else:
#		Inventory_UI.visible = true	
#
#func dropped_switch():
#	if DroppedItems_UI.visible:
#		DroppedItems_UI.visible = false
#
#func close_windows():
#	DroppedItems_UI.visible = false
#	Inventory_UI.visible = false
#	Character_UI.visible = false
