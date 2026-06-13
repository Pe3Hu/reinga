class_name ModifierData
extends TypeData


signal value_changed
signal subvalue_changed

var sanctuary: SanctuaryData
var overlord: Bozo.Overlord
var tooltip: Bozo.Tooltip
var type: Bozo.Modifier:
	set(value_):
		type = value_
		emit_signal("type_changed")
var value: int:
	set(value_):
		value = value_
		emit_signal("value_changed")
var subvalue: int:
	set(value_):
		subvalue = value_
		emit_signal("subvalue_changed")


func _init(sanctuary_: SanctuaryData, overlord_: Bozo.Overlord, type_: Bozo.Modifier) -> void:
	sanctuary = sanctuary_
	overlord = overlord_
	type = type_
	tooltip = Catalog.modifier_to_tooltip[type]
	
	apply_default_value()

func apply_default_value() -> void:
	match overlord:
		Bozo.Overlord.XALVORR:
			value = Catalog.level_modifier_to_percent[sanctuary.xalvorr_level][type]
		Bozo.Overlord.VIRELLO:
			match type:
				Bozo.Modifier.SIN:
					value = Catalog.level_to_modifier_to_range[sanctuary.virello_level][Bozo.Modifier.SIN].front()
					subvalue = Catalog.level_to_modifier_to_range[sanctuary.virello_level][Bozo.Modifier.SIN].back()
				Bozo.Modifier.AMBER:
					value = Catalog.level_to_modifier_to_range[sanctuary.virello_level][Bozo.Modifier.AMBER].front()
					subvalue = Catalog.level_to_modifier_to_range[sanctuary.virello_level][Bozo.Modifier.AMBER].back()
		Bozo.Overlord.KHARZEN:
			value = Catalog.omen_to_percent[type]
		Bozo.Overlord.CALTHEX:
			value = Catalog.level_modifier_to_shift[sanctuary.calthex_level][type]
		Bozo.Overlord.SIREXIL:
			value = Catalog.level_modifier_to_limit[sanctuary.sirexil_level][type]
			
