class_name Aura
extends Area2D

var intercept: bool = false
var shield: float = 0

@onready var statuses = self.get_parent()
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var particles: GPUParticles2D = $Particles
@onready var sprite: Sprite2D = $Bullet
@onready var texture_light: PointLight2D = $TextureLight
@onready var light: PointLight2D = $PointLight

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.connect("body_entered", _on_enter) 
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (intercept):
		for body in self.get_overlapping_bodies():
			if body.get_collider_type() == 'Projectile':
				if body.projectile_owner != self.get_parent().get_parent() and not body.freeze:
					body.delete()
					print(shield)
					shield -= int(body.skill.ranged_damage * body.projectile_owner.get_damage() / 100.0)
					if (shield <= 0):
						statuses.hide_status(Enums.EStatus.SHIELD)


func _on_enter(what):
	pass
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


func get_collider_type():
	return 'Aura'
