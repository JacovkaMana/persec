extends Control

@onready var notification = preload("res://Scenes/Objects/notification.tscn")
@onready var container = $VBoxContainer
@onready var player: PlayerScript = get_tree().get_root().find_child("Player", true, false)
var notification_array = []
var tween
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	player.connect("kill_confirmed", _on_kill)
	player.connect("money_earned", _on_money)
	for i in range(5):
		create_notification(i * pow(10,i)) 
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_kill(who):
	create_notification('Killed ' + who.name)
	
func _on_money(much):
	create_notification('Earned ' + str(much))

func create_notification(text):
	var new_notification = notification.instantiate()
	var new_timer = Timer.new()
	new_notification.get_child(0).get_child(0).text = str(text)
	new_timer.set_wait_time(5)
	new_timer.set_one_shot(true)
	new_timer.timeout.connect(hide_notification.bind(new_notification))  

	container.add_child(new_notification)
	new_notification.reload()
	
	new_notification.add_child(new_timer)
	new_timer.start()

func hide_notification(which):
	if which in container.get_children():
		which.fade()

