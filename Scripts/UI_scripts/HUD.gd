extends Control

@onready var player: PlayerScript = get_tree().get_root().find_child("Player", true, false)
@export var full_material: ShaderMaterial
var SHINE_TIME = 2
var tween


@onready var stamina_bar: TextureProgressBar = $Status/StaminaBar/TextureProgressBar
@onready var stamina_container: TextureRect = $Status/StaminaBar
@onready var stamina_backplate: TextureProgressBar = $Status/StaminaBackplate
@onready var sound_bar = $SoundBar

@onready var health_bar: TextureProgressBar = $Status/HealthBar/TextureProgressBar
@onready var health_label: Label = $Status/HealthLabel

@onready var stamina_blocks = $StaminaContainer

@onready var money_label = $Coins/Label

@onready var statuses_container = $StatusesContainer

# Called when the node enters the scene tree for the first time.

func close_lower():
	$SoundBar.visible = false
	$StaminaContainer.visible = false
	$SkillsHotbar.visible = false
	$ItemsHotbar.visible = false
	$Status.visible = false
	$StatusesContainer.visible = false
	
func _ready():
	
	for i in range(stamina_blocks.get_child_count()):
		stamina_blocks.get_child(i).material = full_material


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	for i in range(stamina_blocks.get_child_count()):
		if (i + 1) <= player.data.max_stamina:
			if (min(player.data.stamina, i + 1) / (i + 1) == 1):
				# visible true 
				stamina_blocks.get_child(i).visible = false
				stamina_blocks.get_child(i).material = full_material
			else:
				stamina_blocks.get_child(i).visible = false

		else:
			stamina_blocks.get_child(i).visible = false
	
	
	
	for i in range(statuses_container.get_child_count()):
		if i < player.data.statuses.size():
			statuses_container.get_child(i).visible = true
			#statuses_container.get_child(i).get_child(0).texture = player.data.statuses[ player.data.statuses.keys(i) ]
		else:
			statuses_container.get_child(i).visible = false
	
	
	stamina_container.size.x = 18 * player.data.max_stamina
	stamina_bar.max_value = player.data.max_stamina * 100.0
	stamina_bar.value = player.data.stamina * 100.0
	stamina_backplate.value = stamina_bar.size.x + 10
	health_bar.max_value = player.data.max_hitpoints
	health_bar.value = player.data.hitpoints
	health_label.text = "{0}/{1}".format([player.data.hitpoints,player.data.max_hitpoints])
	
	money_label.text = str(player.data.money)
	
	
	
	
	sound_bar.get_child(0).material.set("shader_param/power", player.viewer_manager.get_overall_satisfaction());
