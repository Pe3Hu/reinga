class_name ShelterData
extends Resource


var hell: HellData
var modifiers: Array[ModifierData]
var type_to_modifier: Dictionary
var level: int = 1



func _init(hell_: HellData) -> void:
	hell = hell_
	init_modifiers()

func init_modifiers() -> void:
	for type in Catalog.modifiers:
		add_shelter(type)

func add_shelter(type_: Bozo.Modifier) -> void:
	var modifier = ModifierData.new(self, type_)
	modifiers.append(modifier)
	type_to_modifier[type_] = modifier

func get_modifier_weights() -> Dictionary:
	return Catalog.level_modifier_to_percent[level]
