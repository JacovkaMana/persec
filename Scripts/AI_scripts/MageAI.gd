extends BaseAI
class_name MageAI

#var owner: Actor = null
#var target: Actor = null
#var active: bool = false
var dodge_direction = Vector2.ZERO
var visible_projectiles = []

var distance_to_target = 200.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func ai_process(delta):

	if (not active):
		pass
	owner.move_speed = 70
	var angle_enemy = owner.global_position.angle_to(target.global_position)
	var direction_enemy = owner.global_position.direction_to(target.global_position)
	var angle = angle_enemy
	
	if (abs(owner.global_position.distance_to(target.global_position) - distance_to_target) <= distance_to_target*0.1):
		if (dodge_direction == Vector2.ZERO):
			owner.move_direction = 0.00001 * owner.global_position.direction_to(target.global_position)
		else:
			owner.move_direction = dodge_direction
		#ranged_attack()
	elif (owner.global_position.distance_to(target.global_position) > distance_to_target):
		owner.move_direction = (direction_enemy + dodge_direction).normalized()
	elif (owner.global_position.distance_to(target.global_position) < distance_to_target):
		owner.move_direction = -1 *  (direction_enemy + dodge_direction).normalized()
	
	#print( owner.global_position.direction_to(target.global_position) )


#func ai_vision_process(objects):
#	for what in objects:
#		match what.get_collider_type():
#			'Projectile':
#				projectile_coming(what)

func projectile_coming(which):
	var angle = owner.global_position.angle_to(which.global_position)
	var distance = owner.global_position.distance_to(which.global_position)
	var direction = owner.global_position.direction_to(which.global_position)
	var time = distance / which.move_speed
	dodge_direction = Vector2(direction.x - 0.5, direction.y - 0.5).normalized()
	print(dodge_direction)
	#print(time)
	#dodging = true
	if (time < 0.3):
		print('defence')
		use_defence()
	#owner.move_direction += Vector2(cos(_angle - PI/2),sin(_angle - PI/2))

func projectile_exited(which):
	print('exited')
	dodge_direction = Vector2.ZERO

func use_defence():
	for skill in owner.data.skills.get_skills():
		match skill.get_skill_type(): 
			'Status':
				if (skill.get_cost() <= owner.data.stamina):
					owner.data.stamina -= skill.get_cost()
					owner.use_status_skill( skill)
					

func ranged_attack():
	for skill in owner.data.skills.get_skills():
		match skill.get_skill_type(): 
			'Attack':
				if (skill.get_cost() <= owner.data.stamina):
					owner.data.stamina -= skill.get_cost()
					owner.shoot_projectile( skill, target)

