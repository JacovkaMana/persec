class_name HelmItem
extends ArmorItem

func get_item_type():
	return Enums.EItemType.HELM

func get_type_text()->String:
		return "Helm"

func get_slot_type():
	return [Enums.EEquipmentSlot.HELM]
	

func is_equipable()->bool:
	return true



