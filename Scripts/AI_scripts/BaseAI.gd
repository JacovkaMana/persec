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

var roam_timer = null

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
	_timer.connect("timeout", attack) 
	_timer.set_wait_time(attack_pause)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()


func set_roam_timer():
	var t_max = 0
	var t_min = 0
	match owner.current_state:
		Enums.ECharacterState.ROAMING:	
			t_min = 2.0
			t_max = 10.0
		Enums.ECharacterState.FIGHT_RANGE:	
			t_min = 0.1 
			t_max = 1.0
	
	if not roam_timer:		
		roam_timer = Timer.new()
		self.owner.add_child(roam_timer)
		roam_timer.connect("timeout", change_roam_destination) 
		roam_timer.set_one_shot(true) # Make sure it loops
		
	roam_timer.set_wait_time(randf_range(t_min, t_max))
	roam_timer.start()
	

func change_roam_destination():
	match owner.current_state:
		Enums.ECharacterState.ROAMING:	
			owner.nav_agent.target_desired_distance = 30.0
			owner.nav_agent.path_desired_distance = 10.0
			owner.nav_agent.pathfinding_algorithm = 0
			owner.nav_agent.target_position = owner.starting_zone.get_random_pos()
		Enums.ECharacterState.FIGHT_RANGE:	
			owner.nav_agent.target_desired_distance = 100.0
			owner.nav_agent.path_desired_distance = 10.0
			owner.nav_agent.pathfinding_algorithm = 1
			owner.nav_agent.target_position = target.global_position
			#owner.nav_agent.target_position = Vector2(134, 45)
	
func deactivate():
	_timer.queue_free()
	#roam_timer.queue_free()

func is_in_zone(zone, point):
	return zone.shape.get_rect().has_point(point.global_position - point.current_zone.global_position)
	
func roam():
	
	var _additional_position = owner.move_direction * 20
	
	
	
	owner.move_direction = (owner.nav_agent.get_next_path_position() - owner.global_position).normalized()
	
	if owner.nav_agent.is_navigation_finished():
		owner.move_direction = Vector2.ZERO
		
		#set_roam_timer()

		
		
		
		
		
				
				
	## TODO Rail System (NPC unique from export)
	
	
	
	## random raycast-based walk FAILED too random (gets stuck)
	
#	if owner.raycast.is_colliding():
#		#print(owner.raycast.get_collider(0))
#		if owner.raycast.get_collider(0).get_collider_type() == 'TileMap':
#			owner.move_direction = owner.move_direction * -1
#			owner.move_direction = owner.move_direction.rotated(randf_range(-PI / 2, PI / 2)).normalized()
#
#			owner.raycast.target_position = owner.move_direction * 20
#			owner.raycast.force_shapecast_update()

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
func _process(_delta):
	pass
	

func attack():
	match (randi() % 10):
		0:
			strongest_ranged_attack()
		1: 
			strongest_ranged_attack()
		_:
			cheapest_ranged_attack()
					

	
func cheapest_ranged_attack():
	var _min = 10000
	res = null
	for skill in owner.data.skills.get_skills():
		if skill.get_cost() < _min and skill.is_damage_skill:
			res = skill
	if (res):
		if (owner.data.stamina - res.get_cost() >= save_energy):
			owner.data.stamina -= res.get_cost()
			owner.shoot_projectile(res, target)

func strongest_ranged_attack():
	var _max = -1
	res = null
	for skill in owner.data.skills.get_skills():
		if (skill.get_cost() <= owner.data.stamina) and skill.is_damage_skill:
			if skill.damage_value * skill.damage_count > _max:
				res = skill
	if (res):
		owner.data.stamina -= res.get_cost()
		owner.shoot_projectile( res, target)
