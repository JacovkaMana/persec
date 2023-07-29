class_name MeleeProjectile
extends StaticBody2D

var start_pos: Vector2
var moving: bool = false
var direction: Vector2
var animation_tree: AnimationTree = null
var enemies
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var particles: GPUParticles2D = $Particles
@onready var sprite: Sprite2D = $Bullet
@onready var texture_light: PointLight2D = $TextureLight
@onready var light: PointLight2D = $PointLight
@onready var player = get_tree().get_root().find_child("Player", true, false)


#@onready var particles = $GPUParticles2D
#@onready var state_machine = animation_tree.get("parameters/playback")

@export var move_speed : float = 100
@export var move_range: float
@export var moving_projectile: bool = false
@export var animated: bool = false
@export var magic: bool = false
var projectile_owner = null

var skill = null
var collision_object = null
var test_color = preload("res://Art/Colors/Ice.tres")
var freeze: bool = false
var tween

@onready var SceneManager = self.get_tree().get_root().find_child("SceneManager", true, false)
@onready var MeleeScene = self.get_tree().get_root().find_child("MeleeScene", true, false)
# Called when the node enters the scene tree for the first time.



func _ready():
	#damage_signal.connect(_on_signal_damage)
	start_pos = self.position
	if (animation_player):
		#animation_player.connect("animation_finished", _on_animation_finished)
		animation_player.queue("full")
		
#	
	
	
func _on_texture_damage():
	MeleeScene.play_damage(skill)
	for enemy in enemies:
		enemy.take_damage(skill, projectile_owner, null)
		
func _on_cooldown_on():
	print(projectile_owner)
	projectile_owner.in_skill_animation = true
	print('cooldown on')
		
func _on_cooldown_off():
	projectile_owner.in_skill_animation = false
	print('cooldown off')
#
func change_sprite(_skill: Skill):
	#to = skill.projectile
#	sprite.set_texture(to)
#	texture_light.set_texture(to)
	texture_light.color = RandomStats.type_colors[_skill.damage_type] # too many lights
	sprite.self_modulate = RandomStats.type_colors[_skill.damage_type]
	light.color = RandomStats.type_colors[_skill.damage_type]
	if (_skill.type == Enums.ESkillType.MAGIC):
		
		sprite.material = GlobalSkills.shaders[_skill.damage_type]
		particles.process_material.color_ramp = GlobalSkills.colors[_skill.damage_type]
		#sprite.self_modulate.a = 150
		particles.emitting = true
	else:
		sprite.material = null
		particles.emitting = false
		

func _on_animation_finished(_anim):
	
	actually_delete()
	pass
	match _anim:
		"Start":
			delete()
		'delete':
			actually_delete()
	
	
func delete():
	freeze = true
	self.move_speed = 0
	self.direction = Vector2.ZERO
	#move_and_collide(Vector2.ZERO)
	self.constant_linear_velocity = Vector2.ZERO
	self.constant_angular_velocity = 0
	#self.process_mode = Node.PROCESS_MODE_DISABLED
	if animation_player:
		if animation_player.has_animation("delete"):
			animation_player.play("delete")
		else:
			actually_delete()
	else:
		actually_delete()
	
func actually_delete():
	self.queue_free()

func trigger_melee():
	player.trigger_melee()
	
func get_collider_type():
	return 'Projectile'
	
