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
		#print(attack_period)
		

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


func is_in_zone(zone, point):
	return zone.shape.get_rect().has_point(point.global_position - point.current_zone.global_position)
	
func roam():
	
	var additional_position = owner.move_direction * 20
	
	
	## TODO Rail System (NPC unique from export)
	
	
	
	## random raycast-based walk FAILED too random (gets stuck)
	if owner.raycast.get_collider(0):
		if owner.raycast.get_collider(0).get_collider_type() == 'TileMap':
			owner.move_direction = owner.move_direction * -1
			owner.move_direction = owner.move_direction.rotated(randf_range(-PI / 2, PI / 2)).normalized()
			
			owner.raycast.target_position = owner.move_direction * 20
			owner.raycast.force_shapecast_update()

	## random area-based walk FAILED too random + can't detect shit
	
#	if owner.current_zone:
#		print(owner.current_zone.name)
#		in_zone = false
#
#		var _in_zones = owner.current_zone.collision_shapes.any(
#			func(zone) : 
#				#return zone.shape.get_rect().has_point(owner.global_position - owner.current_zone.global_position)
#				return zone.shape.get_rect().has_point(owner.global_position - zone.global_position + additional_position)
#				) 
#		if not _in_zones:
#			owner.move_direction = Vector2(0, 0)


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
