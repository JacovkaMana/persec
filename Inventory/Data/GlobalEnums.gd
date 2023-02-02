extends Node

enum EWeaponSubtype {
	SWORD,
	AXE,
	SPEAR,
	BOW,
	CROSSBOW,
	SHIELD,
	FISTS,
}

enum ERarity {
	Common,
	Uncommon,
	Rare,
	Epic,
	Legendary,
	Unique,
	Special,
}

enum EStatus {
	STANDART = 0,
	BURNING,
}

enum EDamageType {
	STANDARD = 0,
	SLASH,
	PIERCE,
	BLUNT,
	FIRE,
	ICE,
	WIND,
	EARTH,
	LIGHTNING,
	WATER,
}

enum ESkillType {
	STANDARD = 0,
	BLADE,
	POLEARM,
	BLUNT,
	MAGIC,
}

enum EScalingValue {
	NO_SCALING = 0,
	E,
	D,
	C,
	B,
	A,
	S,
}

enum EItemType {
	ITEM,
	WEAPON,
	ARMOR,
	HELM,
	BOOTS,
	AMULET,
	CONSUMABLE,
	NOTE,
}

enum EItemEffectType {
	NONE = 0,
	MAX_HP,
	MAX_FP,
	REGEN_HP,
	MAX_EQUIP_LOAD,
}

enum EEquipmentSlot {
	NONE = 0,
	L_HAND,
	R_HAND,
	HELM,
	ARMOR,
	GLOVES,
	BOOTS,
	AMULET,
	ACCESSORY_1,
	ACCESSORY_2,
	BELT,
	CONSUMABLE_1,
	CONSUMABLE_2,
	CONSUMABLE_3,
	CONSUMABLE_4,
	CONSUMABLE_5,
	CONSUMABLE_6,
}

enum EStat {
	NONE = 0,
	STRENGTH,
	DEXTERITY,
	CONSTITUTION,
	INTELLIGENCE,
	PERCEPTION,
}

enum EModifierType {
	NONE = 0,
	Percent,
	Flat,
	Ability,
}

enum EModifierSubtype {
	NONE = 0,
	Damage,
	Element,
	Armor,
	Hitpoints,	
}
