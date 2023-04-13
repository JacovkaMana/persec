extends Area2D

var intercept: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.connect("body_entered", _on_enter) 
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (intercept):
		for body in self.get_overlapping_bodies():
			if body.get_collider_type() == 'Projectile':
				if body.projectile_owner != self.get_parent().get_parent():
					body.delete()


func _on_enter(what):
	print('Defending trigger')
#	print(what)
#	print(self.get_overlapping_bodies())
#	match what.get_collider_type():
#		"Projectile":
#			if what.projectile_owner != self.get_parent().get_parent():
#				what.delete()
#		"HitBox":
#			print(what.get_parent().name)
#			print(what.get_parent().global_position)
#			print(self.global_position)
#		_:
#			print('something else')


