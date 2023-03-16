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
# !!!!! При закрытии закрывается ItemActionsPanel, если она над этой менюшкой!!!
# Called when the node enters the scene tree for the first time.
func _ready():

	player.connect("dialogue_started", _on_dialogue)



func _on_dialogue(with):
	ui_settings.close_everything()
	self.visible = true
	#ui_settings.pause_game()

