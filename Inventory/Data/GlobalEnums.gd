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

enum EDamageType {
	STANDARD = 0,
	PIERCE,
	STRIKE,
	SLASH,
	STANDARD_PIERCE,
	SLASH_PIERCE,
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
	BOOTS,
	AMULET,
	CONSUMABLE_1,
	CONSUMABLE_2,
	CONSUMABLE_3,
	CONSUMABLE_4,
	CONSUMABLE_5,
	CONSUMABLE_6,
}
