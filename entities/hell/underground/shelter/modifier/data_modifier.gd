class_name ModifierData
extends TypeData


signal value_changed

var shelter: ShelterData
var type: Bozo.Modifier:
	set(value_):
		type = value_
		emit_signal("type_changed")
var value: int:
	set(value_):
		value = value_
		emit_signal("value_changed")


func _init(shelter_: ShelterData, type_: Bozo.Modifier) -> void:
	shelter = shelter_
	type = type_
	value = Catalog.level_modifier_to_percent[shelter.level][type]
