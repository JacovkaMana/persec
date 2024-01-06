extends BaseAI
class_name MageAI


var dodge_direction = Vector2.ZERO
var visible_projectiles = []

var distance_to_target = 200.0


func ai_process(delta):
	super(delta)
	
## MOVED TO TIMER
#	owner.nav_agent.target_desired_distance = 100.0
#	owner.nav_agent.path_desired_distance = 10.0
#	owner.nav_agent.pathfinding_algorithm = 1
#	owner.nav_agent.target_position = target.global_position
	if owner.global_position.distance_to(target.global_position) > 300.0:
		print('deactivate fight')
		owner.current_state = Enums.ECharacterState.ROAMING
		self.deactivate()
		return 3
		
			
	if owner.global_position.distance_to(target.global_position) > 100.0:
		owner.move_direction = (owner.nav_agent.get_next_path_position() - owner.global_position).normalized()
	else:
	#if owner.nav_agent.is_target_reached():
		owner.move_direction = Vector2.ZERO
		

		

## OLD FIGHT ROAM SYSTEM
#	check_projectiles()
#
#	if (not active):
#		pass
#	owner.move_speed = 70
#	var angle_enemy = owner.global_position.angle_to(target.global_position)
#	var direction_enemy = owner.global_position.direction_to(target.global_position)
#	var _angle = angle_enemy
#
#	if (abs(owner.global_position.distance_to(target.global_position) - distance_to_target) <= distance_to_target*0.1):
#		if (dodge_direction == Vector2.ZERO):
#			owner.move_direction = 0.00001 * owner.global_position.direction_to(target.global_position)
#		else:
#			owner.move_direction = dodge_direction
#		#ranged_attack()
#	elif (owner.global_position.distance_to(target.global_position) > distance_to_target):
#		owner.move_direction = (direction_enemy + dodge_direction).normalized()
#	elif (owner.global_position.distance_to(target.global_position) < distance_to_target):
#		owner.move_direction = -1 *  (direction_enemy + dodge_direction).normalized()
	



func projectile_coming(which):
	var _angle = owner.global_position.angle_to(which.global_position)
	var distance = owner.global_position.distance_to(which.global_position)
	var direction = owner.global_position.direction_to(which.global_position)
	var _time = distance / which.move_speed
	dodge_direction = Vector2(direction.x - 0.5, direction.y - 0.5).normalized()


	visible_projectiles.append(which)

		
func check_projectiles():
	if is_instance_valid(owner):
		for proj in visible_projectiles:
			if is_instance_valid(proj):
				var check_distance = owner.global_position.distance_to(proj.global_position)
				var check_time = check_distance / proj.move_speed
				if (check_time < 0.3):
					use_defence()
	#owner.move_direction += Vector2(cos(_angle - PI/2),sin(_angle - PI/2))

func projectile_exited(which):
	dodge_direction = Vector2.ZERO
	if (which in visible_projectiles):
		visible_projectiles.erase(which)

func use_defence():
	for skill in owner.data.skills.get_skills():
		match skill.get_skill_type(): 
			'Status':
				if (skill.get_cost() <= owner.data.stamina):
					owner.data.stamina -= skill.get_cost()
					owner.use_status_skill( skill)
					

func attack():
	match (randi() % 10):
		0:
			strongest_ranged_attack()
		1: 
			strongest_ranged_attack()
		_:
			cheapest_ranged_attack()
					


