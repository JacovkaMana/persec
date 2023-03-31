extends Control

@onready var player: PlayerScript = get_tree().get_root().find_child("Player", true, false)
@export var full_material: ShaderMaterial

@onready var stamina_bar: TextureProgressBar = $StaminaBar/TextureProgressBar
@onready var stamina_container: TextureRect = $StaminaBar
@onready var stamina_backplate: TextureProgressBar = $StaminaBackplate

@onready var health_bar: TextureProgressBar = $HealthBar/TextureProgressBar
@onready var health_label: Label = $HealthLabel
var SHINE_TIME = 2
var tween
# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in range(self.get_child_count()):
		self.get_child(i).material = full_material


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(player.data.stamina)
#	for i in range(self.get_child_count()):
#		if (i + 1) <= player.data.max_stamina:
#			var alpha = min(player.data.stamina, i + 1) / (i + 1)
#			self.get_child(i).self_modulate = Color(alpha,alpha,alpha, alpha)
#			#self.get_child(i).self_modulate = Color(1,1,1, alpha)
#			if (alpha == 1):
#				self.get_child(i).material = full_material
#			else:
#				self.get_child(i).material = null
#
#		else:
#			self.get_child(i).visible = false
	stamina_container.size.x = 18 * player.data.max_stamina
	stamina_bar.max_value = player.data.max_stamina * 100.0
	stamina_bar.value = player.data.stamina * 100.0
	stamina_backplate.value = stamina_bar.size.x + 10
	health_bar.max_value = player.data.max_hitpoints
	health_bar.value = player.data.hitpoints
	health_label.text = "{0}/{1}".format([player.data.hitpoints,player.data.max_hitpoints])
