extends Node

@onready var armor = {
	Enums.EArmorType.PLATE : [
		preload("res://Art/Sprites/Armor/Armor1.png"),
		preload("res://Art/Sprites/Armor/Armor2.png"),
	],
}

@onready var boots = {
	Enums.EArmorType.PLATE : [
		preload("res://Art/Sprites/Boots/Boots1.png"),
		preload("res://Art/Sprites/Boots/Boots2.png"),
	],
}

@onready var helm = {
	Enums.EArmorType.PLATE : [
		preload("res://Art/Sprites/Helmets/Helm1.png"),
	],
}

@onready var pants = {
	Enums.EArmorType.PLATE : [
		preload("res://Art/Sprites/Armor/Armor2.png"),
	],
}

@onready var weapon = {

		Enums.EWeaponSubtype.SWORD : [
			preload("res://Art/Sprites/Weapon/Sword1.png"),
		],
		Enums.EWeaponSubtype.AXE : [
			preload("res://Art/Sprites/Weapon/Axe1.png"),
		],
		Enums.EWeaponSubtype.SPEAR : [
			preload("res://Art/Sprites/Weapon/Spear1.png"),
		],
		Enums.EWeaponSubtype.BOW : [
			preload("res://Art/Sprites/Weapon/Bow1.png"),
		],
		Enums.EWeaponSubtype.CROSSBOW : [
			preload("res://Art/Sprites/Weapon/Bow1.png"),
		],
		Enums.EWeaponSubtype.SHIELD : [
			preload("res://Art/Sprites/Weapon/Sword1.png"),
		],
		Enums.EWeaponSubtype.FISTS : [
			preload("res://Art/Sprites/Weapon/Sword1.png"),
		],
}

@onready var skill_icons = {
	"single_59" : preload("res://Art/Icons/Skills/single_59.png"),
	"single_41" : preload("res://Art/Icons/Skills/single_41.png"),
	"single_6" : preload("res://Art/Icons/Skills/single_6.png"),
}

# Called when the node enters the scene tree for the first time.
func _init():
	pass
