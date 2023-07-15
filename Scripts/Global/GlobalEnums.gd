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
	FIGHT_RANGE,
	FIGHT_MELEE,
}

enum ECharacterBehaviour {
	FRIENDLY,
	NEUTRAL,
	HOSTILE,
}

enum ECharacterBattleTrait{
	NORMAL,
	ACCURATE,
	RECKLES,
}

enum ECharacterActions{
	NONE = 0,
	TALK,
	TRADE
}

enum EArmorType {
	NONE = 0,
	CLOTH,
	LEATHER,
	PLATE,
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
	DEFEND,
	BURN,
	SHIELD,
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
	MELEE,
	RANGED,
	MAGIC,
	GENERAL
}


enum ESkillSubtype {
	NONE = 0,
	SLASHING,
	PIERCE,
	CRUSH,
	FIRE,
	ICE,
	
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
	GLOVES,
	BOOTS,
	AMULET,
	CONSUMABLE,
	NOTE,
}


enum EEquipType {
	NONE = 0,
	WEAPON,
	ARMOR,
	HELM,
	PANTS,
	GLOVES,
	BOOTS,
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
	PANTS,
	BOOTS,
	GLOVES,
	AMULET,
	ACCESSORY_1,
	ACCESSORY_2,
	CHARACTER,
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
	#Ability,
}

enum EModifierSubtype {
	NONE = 0,
	Physical_Damage,
	Fire_Damage,
	Ice_Damage,
	Wind_Damage,
	Earth_Damage,
	Thunder_Damage,
	Water_Damage,
	Armor,
	Evasion,
	Hitpoints,
}

enum EItemActions {
	NONE = 0,
	DROP,
	USE,
	EQUIP,
	UNEQUIP,
}
