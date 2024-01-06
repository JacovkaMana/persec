extends Control

@onready var menu_options = $HideableContent/MenuOptions
@onready var menu_name = $MenuHeader/MenuName
@onready var menu_desc = $MenuHeader/MenuDesc
@onready var option_desc = $HideableContent/MenuOptionDesc/Label
@onready var journal_content = $JournalContent
@onready var journal = $JournalContent/Journal
@onready var hideable_content = $HideableContent
@onready var return_button = $ReturnButton
@onready var journal_tab = $JournalContent/MenuTabs

# Called when the node enters the scene tree for the first time.
func _ready():
	journal_tab.set_tab_disabled(1, true)
	return_button.connect("pressed", option_clicked.bind("Return"))
	for option in menu_options.get_children() as Array[Control]:
		option.get_child(0).connect("pressed", option_clicked.bind(option.get_child(0).name))
		option.get_child(0).connect("mouse_entered", option_hovered.bind(option.get_child(0).name))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func option_clicked(option_name: String):
	match option_name:
		"Journal":
			menu_name.text = "Journal"
			menu_desc.text = "View quest details"
			for quest_n in range(journal.get_children().size()):
				journal.get_child(quest_n).get_child(0).connect("pressed", quest_clicked.bind(quest_n))
			journal_content.visible = true
			hideable_content.visible = false
			return_button.visible = true
		"Return":
			menu_name.text = "Main menu"
			menu_desc.text = "Select an option"
			journal_tab.set_tab_disabled(1, true)
			return_button.visible = false
			journal_content.visible = false
			hideable_content.visible = true
				
				
func option_hovered(option_name: String):
	match option_name:
		"Skills":
			option_desc.text = "Edit the character's skills"
		"Party":
			option_desc.text = "Edit your party"
		"Journal":
			option_desc.text = "View quest details and locations"
		"DataBank":
			option_desc.text = "View enemy/weapon data"
		"Config":
			option_desc.text = "Configure game settings"
				

func quest_clicked(_quest_n: int):
	journal_tab.set_tab_disabled(1, false)
