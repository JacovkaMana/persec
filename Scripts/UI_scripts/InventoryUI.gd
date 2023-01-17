extends Control

@onready var inventory_grid: GridContainer = get_node("InventoryGrid")
@onready var desc_panel: Panel = get_node("ItemDescPanel")
@onready var player = get_tree().get_root().find_child("Player", true, false)
var ItemPanel = preload('res://Inventory/ItemButton.tscn')
# Called when the node enters the scene tree for the first time.
func _ready():
	
	#print('Player test node')
	#print(player.inventory)
	player.inventory.connect("added_item", _on_new_item)
	player.inventory.connect("updated_item", _on_updated_item)
	
	# По хорошему обновление должно идти из кнопки, т.е. при открытии инвентаря по 
	# дефолту выбрана вкладка 'Все предметы' и оттуда загружаются все предметы
	# Хз верхним кнопкам отдельный нужен скрипт или как это сделать
	
	for slot in inventory_grid.get_children() as Array[ItemSlotUI]:
		slot.connect("slot_mouse_entered", _on_slot_mouse_entered)
		slot.connect("slot_mouse_click", _on_slot_mouse_click)
		slot.connect("slot_mouse_exited", _on_slot_mouse_exited)
		
		if (not slot.item):
			slot.item = Item.new()
				
	pass # Replace with function body.


func _on_new_item(new_item)->bool:
	#print(new_item)
	
	var newItemPanel = ItemPanel.instantiate()
	
	inventory_grid.add_child(newItemPanel)
	
	newItemPanel.set_item(new_item)
	if (new_item.is_stackable()):
		newItemPanel.find_child("ItemCount").text = str(new_item.count)
		newItemPanel.find_child("ItemCount").visible = true
		
	
	newItemPanel.connect("slot_mouse_entered", _on_slot_mouse_entered)
	newItemPanel.connect("slot_mouse_exited", _on_slot_mouse_exited)
	newItemPanel.connect("slot_mouse_click", _on_slot_mouse_click)
	
	return true
	
func _delete_item(item)->bool:
	for slot in inventory_grid.get_children() as Array[ItemSlotUI]:
		if slot.item == item:
			inventory_grid.remove_child(slot)
			return true
	return false

func _on_updated_item(new_item)->bool:
	
	_delete_item(new_item)
	_on_new_item(new_item)
	
	return true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_slot_mouse_click(slot: BaseSlotUI):
	print("clicked")
	if !desc_panel.visible:
		desc_panel.find_child("NameLabel").text = slot.item.name;
		desc_panel.find_child("DescLabel").text = slot.item.description;
		desc_panel.visible = true;
	else:
		desc_panel.visible = false;
		desc_panel.position = Vector2(-84,32);
		
	pass
	
func _on_slot_mouse_entered(slot: BaseSlotUI):
	
	pass

func _on_slot_mouse_exited(item: BaseSlotUI):
	
	pass
