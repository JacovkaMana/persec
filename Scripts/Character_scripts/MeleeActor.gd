extends Control
class_name MeleeActor

@onready var animation_tree = $AnimationTree
@onready var label = $HeadLabel
@onready var sprite = $Sprite


@onready var MeleeScene = self.get_tree().get_root().find_child("MeleeScene", true, false)
#@onready var state_machine = animation_tree.get("parameters/playback")


var data : PlayerData = null
var instantiated: bool = false

var test_melee_proj = load('res://PreRendered/MeleeProjectiles/Slash.tscn')

var in_skill_animation: bool = false
@onready var Projectiles = self.get_tree().get_root().find_child("MeleeProjectiles", true, false)
@onready var Statuses = $Statuses




var look_at: Node2D = null

func _ready():
	pass
#	if not (data):
#		data = PlayerData.new()
#	#update_animation_parameters(starting_direction, Vector2(0.,0.))
#
#
#	animation_tree.connect("animation_finished", _on_anim_finished)
#
#	#animation_player.connect("animation_finished", _on_anim_finished)
#
#	animation_tree.set("parameters/walking/current_state", "walking")


func update_animation_parameters (direction: Vector2, velocity):
	pass

	
func _physics_process(_delta):
	if (instantiated):
		if (self.data.stamina < self.data.max_stamina):
			self.data.stamina += _delta * self.data.stamina_regen / 20.0
			if (self.data.stamina > self.data.max_stamina):
				self.data.stamina = self.data.max_stamina
				
		


func shoot_melee_projectile(skill: Skill, at) -> void:
	
	
	var proj = skill.projectile
	#var bullet = proj.instantiate()
	var bullet = test_melee_proj.instantiate()
				
	if skill.type == Enums.ESkillType.MAGIC:
		bullet.magic == true
	
		

	if skill.is_damage_skill:
		Projectiles.add_child(bullet)

		
		
		bullet.skill = skill
		bullet.enemies = [at]
		bullet.projectile_owner = self
		bullet.change_sprite(skill)		
		bullet.global_position = at.global_position
		bullet.global_position.y += 32





func use_skill_id(id: int):
	if id < data.skills.get_skills().size():
		if (data.skills.get_skill_id(id).get_cost() <= data.stamina):
			data.stamina -= data.skills.get_skill_id(id).get_cost()
			#emit_signal("skill_used", id)
#		match data.skills.get_skill_id(id).get_skill_type(): 
#			'Attack':
#				shoot_projectile( data.skills.get_skill_id(id))
#			'Status':
#				use_status_skill( data.skills.get_skill_id(id))
				
	
		
	
func take_damage(_skill: Skill, from, _strength):
	data.hitpoints -= int(_skill.damage_value * from.get_attack() / 100.0)
	#print(int(_skill.ranged_damage * from.get_damage() / 100.0))
	self.modulate = Color8(255,0,0,255)
	if (data.hitpoints <= 0):
		self.visible = false
		MeleeScene.check_for_melee_end()
		#animation_tree.set("parameters/death/transition_request", "true")
		#player.kill_confirm(self)
	
	#cooldown(1)

#func reset_after_hit():
#	self.modulate = Color8(255,255,255,255)
#	label.visible = false
#	head_timer = null
#
#func cooldown(time):
#	head_timer = Timer.new()
#	label.visible = true
#
#
#	head_timer.set_wait_time(time)
#	head_timer.set_one_shot(true)
#	head_timer.connect("timeout", reset_after_hit)  
#	add_child(head_timer)
#	head_timer.start()
#
#
#func set_zone(to):
#	current_zone = to

func _on_anim_finished(name):
	pass


func get_attack():
	if	data.inventory.get_equipments_slot(Enums.EEquipmentSlot.R_HAND):
		return data.inventory.get_equipments_slot(Enums.EEquipmentSlot.R_HAND).get_flat_damage()
	else:
		return data.stats[Enums.EStat.STRENGTH]
		
func use_status_skill(skill: Skill):
	
	if (skill.self_status):
			self.initiate_status(skill, skill.self_status, skill.status_duration)



func initiate_status(skill: Skill, status: Enums.EStatus, duration: int):
	if status == Enums.EStatus.NONE:
		return 0 
		
	var status_timer =  ( self.data.add_status( status, duration) )
	if (status_timer):

		self.add_child(status_timer)

		#self.Statuses.show_status(skill.self_status)
	print(Enums.EStatus.find_key(status))
	match status:
			null:
				pass
			Enums.EStatus.DEFEND:
				self.Statuses.show_status(status)
			Enums.EStatus.SHIELD:
				self.Statuses.shield(skill, status, duration, data.stats[Enums.EStat.INTELLIGENCE] * 10.0)
#
	status_timer.timeout.connect( self.Statuses.hide_status.bind(status) ) 
	
	
	status_timer.start()


