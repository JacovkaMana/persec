extends Node

var rarity_chances: Dictionary = {
	Enums.ERarity.Common : 50,	 
	Enums.ERarity.Uncommon : 30,	 
	Enums.ERarity.Rare : 10,	 
	Enums.ERarity.Epic : 7.5,	 
	Enums.ERarity.Legendary : 2.5,	 
}

var rarity_colors: Dictionary = {
	Enums.ERarity.Common : Color8(225,225,225),	 
	Enums.ERarity.Uncommon : Color8(135,255,135),	 
	Enums.ERarity.Rare : Color8(135,135,255),	 
	Enums.ERarity.Epic : Color8(225,135,255),	 
	Enums.ERarity.Legendary : Color8(255,225,135),	 
}

var type_colors: Dictionary = {
	Enums.EDamageType.SLASH : Color8(225,225,225),
	Enums.EDamageType.PIERCE : Color8(225,225,225),
	Enums.EDamageType.BLUNT : Color8(225,225,225),
	Enums.EDamageType.FIRE : Color8(255,70,70),
	Enums.EDamageType.ICE : Color8(70,160,225),
	Enums.EDamageType.WIND : Color8(225,225,255),
	Enums.EDamageType.EARTH : Color8(70,255,70),
	Enums.EDamageType.THUNDER : Color8(255,225,135),
	Enums.EDamageType.WATER : Color8(135,135,255),
}

var weapon_damagetype: Dictionary= {
	Enums.EWeaponSubtype.SWORD : Enums.EDamageType.SLASH,
	Enums.EWeaponSubtype.AXE : Enums.EDamageType.SLASH,
	Enums.EWeaponSubtype.SPEAR : Enums.EDamageType.PIERCE,
	Enums.EWeaponSubtype.BOW : Enums.EDamageType.PIERCE,
	Enums.EWeaponSubtype.CROSSBOW : Enums.EDamageType.PIERCE,
	Enums.EWeaponSubtype.SHIELD : Enums.EDamageType.BLUNT,
	Enums.EWeaponSubtype.FISTS : Enums.EDamageType.BLUNT,
}

var weapon_damage_gap: Dictionary= {
	Enums.EWeaponSubtype.SWORD : 10,
	Enums.EWeaponSubtype.AXE : 10,
	Enums.EWeaponSubtype.SPEAR : 10,
	Enums.EWeaponSubtype.BOW : 10,
	Enums.EWeaponSubtype.CROSSBOW : 10,
	Enums.EWeaponSubtype.SHIELD :10,
	Enums.EWeaponSubtype.FISTS : 10,
}

func _init():
	pass

func random_rarity():
	var score = randf_range(0,100)
	var rarity = null
	var rarity_chance = 0
	for rarity_score in rarity_chances.keys():
		if score >= rarity_chance:
			rarity = Enums.ERarity.keys()[rarity_score]
			rarity_chance += rarity_chances[rarity_score]
	return Enums.ERarity.get(rarity)


func random_damage(mid_damage: int, type: Enums.EWeaponSubtype):
	var max_gap = round(float(mid_damage) / 100 * weapon_damage_gap[type])
	var var_low = mid_damage - randi_range(0, max_gap)
	var var_high = mid_damage + randi_range(0, max_gap)
	return [var_low, var_high]
	
