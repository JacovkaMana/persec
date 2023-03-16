extends Node

enum EPlayerState {
	NONE = 0,
	ROAMING,
	TALKING,
	RANGE,
	MELEE,
}

enum ECharacterState {
	NONE = 0,
	IDLE,
	ROAMING,
	TALKING,
	SEARCHING,
	RANGE,
	MELEE,
}

enum EWeaponSubtype {
	NONE = 0,
	SWORD,
	AXE,
	SPEAR,
	BOW,
	CROSSBOW,
	SHIELD,
	FISTS,
}

enum ERarity {
	NONE = 0,
	Common,
	Uncommon,
	Rare,
	Epic,
	Legendary,
	Unique,
	Special,
}

enum EStatus {
	NONE = 0,
	BURNING,
}

enum EDamageType {
	NONE = 0,
	SLASH,
	PIERCE,
	BLUNT,
	FIRE,
	ICE,
	WIND,
	EARTH,
	THUNDER,
	WATER,
}

enum ESkillType {
	NONE = 0,
	BLADE,
	POLEARM,
	BLUNT,
	MAGIC,
}

enum EScalingValue {
	NONE = 0,
	E,
	D,
	C,
	B,
	A,
	S,
}

enum EItemType {
	NONE = 0,
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
	CHARACTER
}

enum EStat {
	NONE = 0,
	STRENGTH,
	DEXTERITY,
	CONSTITUTION,
	INTELLIGENCE,
	PERCEPTION,
	CHARISMA,
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

enum EItemActions {
	NONE = 0,
	DROP,
	USE,
	EQUIP,
	UNEQUIP,
}
