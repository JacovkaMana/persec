extends StaticBody2D

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
var starting_material
var created_by = null

@export var random: bool = false
@export var random_items: int = 0

@export var chest_inventory: Array[Item] = []
@onready var interaction_hint = $InteractionHint
@onready var interaction_area = $InteractionArea
@onready var interaction_hint_player = $InteractionHint/AnimationPlayer
@onready var player = get_tree().get_root().find_child("Player", true, false)

@export var interactable: bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	#var idle = anim.get_animation('torch_loop')
	#idle.set_loop(true)
	anim.queue('chest_closed')
	starting_material = sprite.material
	sprite.material = null

	#self.connect("mouse_entered", _mouse_entered)
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	self.connect("input_event", _on_input)
	
	if (random):
		chest_inventory = []
		for i in range(random_items):
			var random_item
			if randi() % 2 == 1:
				random_item = RandomStats.random_armor.pick_random().new(
					'',
					'random generated',
					''
				)
			else:
				random_item = WeaponItem.new(
			'',
			'random generated',
			null,
			0,
			30
			)
			chest_inventory.append(random_item)

	

func remove_item(item: Item):
	if item in chest_inventory:
		chest_inventory.erase(item)
		
		if chest_inventory == []:
			interactable = false
			interaction_hint_player.queue("RESET")
			interaction_hint.visible = false
			if (created_by):
				self.queue_free()
		return true
	return false

func _on_input(_viewport, event, _idx):
	#print('button down')
	#print(event)
	#print(event.is_pressed())
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == 1:
				pass
#			if event.button_index == 2:
#				print('Right_click press')
				
		else:
			#if event.button_index == 1:
				#print('Left_click release')	
				#reset_position()
			if event.button_index == 2:
				#print('Right_click release on chest')
				if interaction_area.overlaps_area(player.interaction_area):
					interact()

func _on_mouse_entered():
	#anim.play('chest_opened')
	sprite.material = starting_material
	
	
func _on_mouse_exited():
	#anim.play('chest_closed')
	sprite.material = null
	
	
func on_interact_area():
	if (interactable):
		interaction_hint_player.queue("float")
		interaction_hint.visible = true
	
func off_interact_area():
	if (interactable):
		interaction_hint_player.queue("RESET")
		interaction_hint.visible = false
	
func interact():
	if (interactable):
		player.emit_signal("dropped_inventory_opened", self)
		anim.play('chest_opened')
