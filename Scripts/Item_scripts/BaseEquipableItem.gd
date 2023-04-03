class_name BaseEquipableItem
extends Item

@export var max_durability: float = 1.0
@export var modifiers: Array[Modifier] = []
@export var item_stats: Dictionary = {}
@export var item_level: int = 1

func get_item_actions():
	return [Enums.EItemActions.EQUIP, Enums.EItemActions.DROP]

func generate_modifiers():
	#print(self.rarity, Enums.ERarity.keys()[self.rarity])
	for i in range(self.rarity - 1):
		self.modifiers.append(
				Modifier.new(self)
			)
