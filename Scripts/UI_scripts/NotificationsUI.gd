extends Control

@onready var notification = preload("res://Scenes/Objects/notification.tscn")
@onready var container = $VBoxContainer
@onready var player: PlayerScript = get_tree().get_root().find_child("Player", true, false)
@onready var quest = $QuestNotification
@onready var animator = $AnimationPlayer

var curr_quest: Quest
var notification_array = []
var tween
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	player.connect("kill_confirmed", _on_kill)
	player.connect("money_earned", _on_money)
	
	player.connect("new_quest", _on_quest)
	
	for i in range(5):
		create_notification(i * pow(10,i)) 
	
	animator.connect("animation_finished", _on_anim_finished)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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


func _on_quest(_quest):
	curr_quest = _quest
	animator.queue('quest')
	
func _on_anim_finished(_name):
	match _name:
		"quest":
			print(curr_quest.difficulty)
			quest.find_child("VBoxContainer").find_child("Difficulty").text = 'Difficulty: ' + curr_quest.difficulty
			quest.find_child("VBoxContainer").find_child("Target").text = 'Target: ' + curr_quest.target_name
			quest.find_child("VBoxContainer").find_child("Reward").text = 'Reward: ' + curr_quest.reward_name
			quest.find_child("VBoxContainer").find_child("Failure").text = 'Failure: ' + curr_quest.failure_name
			quest.find_child("Description").text =  curr_quest.description
			quest.find_child("Type").text = curr_quest.type
			quest.find_child("Name").text = curr_quest.name
			quest.visible = false
			quest.visible = true
