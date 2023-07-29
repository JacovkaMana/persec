extends MeleeActor
class_name MeleePlayer

signal dropped_inventory_opened(item_array: Array[Item])
signal dialogue_started(with: String, text: String)
signal dialogue_ended()
signal skill_used(skill_id: int)
signal kill_confirmed(who: Actor)
signal money_earned(much: int)


var invincible_timer = null
var player_state: Enums.EPlayerState = Enums.EPlayerState.MELEE

@onready var MeleeTriggerArea: Area2D = $MeleeTriggerArea
@onready var SceneManager = self.get_tree().get_root().find_child("SceneManager", true, false)




func save():
	SceneManager.save_resource(self.data, 'user://player_data.res')

func _ready():
	super()
	InputManager.player = self
	#data.recalculate_stats()


func _physics_process(_delta):
	super(_delta)
	
					
	

	

func use_skill_id(id: int):
	print(in_skill_animation)
	if in_skill_animation:
		return false
	
	
	if id < data.skills.get_skills().size():
		if (data.skills.get_skill_id(id).get_cost() <= data.stamina):
			data.stamina -= data.skills.get_skill_id(id).get_cost()
			emit_signal("skill_used", id)
			print(data.skills.get_skill_id(id))
			
			if data.skills.get_skill_id(id).is_damage_skill:
				shoot_melee_projectile( data.skills.get_skill_id(id), MeleeScene.get_enemy_node(0) )


func take_damage(_skill: Skill, from, _strength):
	data.hitpoints -= int(_skill.damage_value * from.get_attack() / 100.0)
	#print(int(_skill.ranged_damage * from.get_damage() / 100.0))
	self.modulate = Color8(255,0,0,255)
	
	
#func trigger_dialogue(with):
#	var dialogue_text = with.get_dialogue()
#	print(dialogue_text)
#	if dialogue_text == null:
#		player_state = Enums.EPlayerState.ROAMING
#		with.current_state = Enums.ECharacterState.ROAMING
#		emit_signal("dialogue_ended")
#	else:
#		print("Dialogue with " + str(with))
#		emit_signal("dialogue_started", with.npc_name, dialogue_text)
#		self.player_state = Enums.EPlayerState.TALKING
#		with.current_state = Enums.ECharacterState.TALKING
#


func kill_confirm(who):
	emit_signal("kill_confirmed", who)
	money_earn(20)
	
func money_earn(much):
	self.data.money += much
	emit_signal("money_earned", much)
	
	
func detrigger_melee():
	pass
	
	

