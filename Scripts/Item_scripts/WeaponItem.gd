class_name WeaponItem
extends BaseEquipableItem

@export var level: int = 1
@export var weapon_type: Enums.EWeaponSubtype = Enums.EWeaponSubtype.NONE
@export var damage_type: Enums.EDamageType = Enums.EDamageType.NONE
@export var stamina_cost: float = 1.0

@export var damage_low: int = 0
@export var damage_high: int = 0
@export var damage: String = ''

func _init(_name: String = '', _description: String = '', _rarity = null, _type = Enums.EWeaponSubtype.NONE, _damage: int = 0):
	
	sprite = preload("res://Art/Sprites/Weapon/Sword1.png")
	
	self.description = _description
	
	if (_rarity):
		self.rarity = _rarity
	else: 
		self.rarity = RandomStats.random_rarity()

	if (_type):
		self.weapon_type = _type
	else:
		self.weapon_type = Enums.EWeaponSubtype.get(
			Enums.EWeaponSubtype.keys()[randi() % (Enums.EWeaponSubtype.size() - 1) + 1]
		)
		
	self.damage_type = RandomStats.weapon_damagetype[self.weapon_type]
	
	if (_name):
		self.name = _name
	else:
		self.name = Enums.EWeaponSubtype.keys()[self.weapon_type]
		
	var rad_damage = RandomStats.random_damage(_damage, self.weapon_type)
	self.damage_low = rad_damage[0]
	self.damage_high = rad_damage[1]
	self.damage = str(rad_damage[0]) + ' - ' + str(rad_damage[1])
	
	generate_modifiers()



func get_item_type():
	return Enums.EItemType.WEAPON
	
func get_equip_type():
	return Enums.EEquipType.WEAPON
	
func get_slot_type():
	return [Enums.EEquipmentSlot.R_HAND, Enums.EEquipmentSlot.L_HAND]

func is_equipable()->bool:
	return true
	
func get_flat_damage()->int:
	return randi_range(damage_low,damage_high)


