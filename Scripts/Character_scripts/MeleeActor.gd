extends CharacterBody2D
class_name MeleeActor

@export var move_direction: Vector2 = Vector2(0,0)
@onready var animation_tree = $AnimationTree
@onready var label = $HeadLabel
@onready var sprite = $Sprite
@onready var state_machine = animation_tree.get("parameters/playback")
var data = PlayerData.new()
var asd: ParticleProcessMaterial
@export var walking = true
var last_move
var head_timer

func _ready():
	pass



		

	
func _physics_process(_delta):
	pass
	

	
func use_skill_id(id: int):
	pass
	

	
func take_damage(skill: BaseSkill, strength):
	data.hitpoints -= 20
	self.modulate = Color8(255,0,0,255)
	
	cooldown(1)

func reset_after_hit():
	self.modulate = Color8(255,255,255,255)
	label.visible = false
	head_timer = null

func cooldown(time):
	head_timer = Timer.new()
	label.visible = true


	head_timer.set_wait_time(time)
	head_timer.set_one_shot(true)
	head_timer.connect("timeout", reset_after_hit)  
	add_child(head_timer)
	head_timer.start()
