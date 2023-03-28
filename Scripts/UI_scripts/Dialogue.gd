extends Control

@onready var inventory_grid: GridContainer = $InventoryGrid
@onready var player = get_tree().get_root().find_child("Player", true, false)
@onready var desc_panel: Panel = $ItemDescPanel
@onready var actions_panel: Panel = get_tree().get_root().find_child("ItemActionsPanel", true, false)


var active_item_lclick: Item = null
var active_slot_rclick: BaseSlotUI = null
var panel_hover = false
var ItemButton = preload("res://Scenes/Inventory/ItemButton.tscn")

var _item_inventory = null

@onready var ui_settings = get_parent()
@onready var bground = $Background
@onready var shadow = $Shadow
@onready var name_label = $Name/Label
# !!!!! При закрытии закрывается ItemActionsPanel, если она над этой менюшкой!!!
# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("dialogue_started", _on_dialogue)
	player.connect("dialogue_ended", _on_dialogue_ended)



func _on_dialogue(with, text):
	ui_settings.close_everything()
	bground.get_child(0).text = text
	name_label.text = with
	self.visible = true
	#ui_settings.pause_game()


func _on_dialogue_ended():
	self.visible = false
