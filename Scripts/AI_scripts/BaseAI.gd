extends Resource
class_name BaseAI


var owner: Actor = null
var target: Actor = null
var active: bool = false
var attack_pause = 2
var save_energy = 1



var attack_period: float = 0
var attack_time = 0
var _timer
var res = null

func ai_process(delta):
	attack_time += delta
	if attack_time > attack_period or owner.data.stamina == owner.data.max_stamina:
		attack()
		attack_time = 0
		attack_period = float(attack_pause) + randf_range(-0.5, 0.5) * attack_pause
		print(attack_period)
		

func setup(_owner, _target):
	
	if (active):
		deactivate()
		
	self.owner = _owner
	self.target = _target
	active = true
	
	_timer = Timer.new()
	self.owner.add_child(_timer)
	#_timer.connect("timeout", attack) 
	_timer.set_wait_time(attack_pause)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()

func deactivate():
	_timer.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func attack():
	pass
	
func cheapest_ranged_attack():
	var min = 10000
	res = null
	for skill in owner.data.skills.get_skills():
		match skill.get_skill_type(): 
			'Attack':
				if (skill.get_cost() <= owner.data.stamina):
					if skill.get_cost() < min and skill.moving_projectile:
						res = skill
	if (res):
		if (owner.data.stamina - res.get_cost() >= save_energy):
			owner.data.stamina -= res.get_cost()
			owner.shoot_projectile(res, target)

func strongest_ranged_attack():
	var max = -1
	res = null
	for skill in owner.data.skills.get_skills():
		match skill.get_skill_type(): 
			'Attack':
				if (skill.get_cost() <= owner.data.stamina):
					if skill.ranged_damage > max and skill.moving_projectile:
						res = skill
	if (res):
		owner.data.stamina -= res.get_cost()
		owner.shoot_projectile( res, target)
