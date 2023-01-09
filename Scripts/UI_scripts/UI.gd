extends Control

var Character
var Inventory
# Called when the node enters the scene tree for the first time.
func _ready():
	#Character = get_tree().get_root().get_node("GameLevel").find_child("Player")
	Character = self.get_node('Character')
	Inventory = self.get_node('Inventory')
	#print(node)
	pass # Replace with function body.


func _input(event):
	
	if event.is_action_pressed("character"):
		
		if Character.visible:
			Character.visible = false
		else:
			Character.visible = true	
			
			
	if event.is_action_pressed("inventory"):
		
		if Inventory.visible:
			Inventory.visible = false
		else:
			Inventory.visible = true	
			
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_viewport())
	pass


func _on_item_container_mouse_entered():
	pass # Replace with function body.
