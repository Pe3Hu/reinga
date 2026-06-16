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
	var rank_index = sanctuary.world.throne.type_to_overlord[overlord].rank + Catalog.OVERLORD_MAX_RANK
	
	if Catalog.modifier_to_rank_to_value.has(type):
		value = Catalog.modifier_to_rank_to_value[type][rank_index]
	
	match overlord:
		Bozo.Overlord.VIRELLO:
			subvalue = Catalog.deal_scope
		Bozo.Overlord.MARVONE:
			value = Catalog.omen_to_percent[type]
	
	match type:
		Bozo.Modifier.TRUST:
			value = Catalog.TRUST_LIMIT
		Bozo.Modifier.HOPE:
			value = Catalog.HOPE_LIMIT
		Bozo.Modifier.BALLET:
			value = Catalog.AMBER_SHIFT
		Bozo.Modifier.PUPPETRY:
			value = Catalog.ATTITUDE_SHIFT
		Bozo.Modifier.OPERA:
			value = Catalog.FLAME_SHIFT
	
	 
