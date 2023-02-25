class_name WeaponItem
extends BaseUndurableItem

@export var level: int = 1
@export var weapon_type: Enums.EWeaponSubtype = 0
@export var damage_type: Enums.EDamageType = 0
@export var stamina_cost: float = 1.0

@export var damage_low: int = 0
@export var damage_high: int = 0
@export var damage: String = ''

@export var modifiers: Array[Modifier] = []


func initialize(name: String = '', description: String = '', rarity = null, type = 0, damage: int = 0):
	
	sprite = preload("res://Art/Sprites/Weapon/Sword1.png")
	
	self.description = description
	
	if (rarity):
		self.rarity = rarity
	else: 
		self.rarity = RandomStats.random_rarity()

	if (type):
		self.weapon_type = type
	else:
		self.weapon_type = Enums.EWeaponSubtype.get(
			Enums.EWeaponSubtype.keys()[randi() % (Enums.EWeaponSubtype.size() - 1) + 1]
		)
		
	self.damage_type = RandomStats.weapon_damagetype[self.weapon_type]
	
	if (name):
		self.name = name
	else:
		self.name = Enums.EWeaponSubtype.keys()[self.weapon_type]
		
	var _damage = RandomStats.random_damage(damage, self.weapon_type)
	self.damage_low = _damage[0]
	self.damage_high = _damage[1]
	self.damage = str(_damage[0]) + ' - ' + str(_damage[1])
	
	self.modifiers.append(
		Modifier.new()
	)

func get_item_type():
	return Enums.EItemType.WEAPON
	
func get_slot_type():
	return [Enums.EEquipmentSlot.R_HAND, Enums.EEquipmentSlot.L_HAND]


