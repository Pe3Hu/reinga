class_name ShelterData
extends Resource


var hell: HellData
var modifiers: Array[ModifierData]
var type_to_modifier: Dictionary



func _init(hell_: HellData) -> void:
	hell = hell_

func _init_modifiers() -> void:
	for type in Catalog.modifiers:
		pass
