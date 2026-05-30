class_name FactionData
extends TokenData


var fate: FateData
var type: Bozo.Faction:
	set(value_):
		type = value_
		emit_signal("type_changed")


func _init(fate_: FateData) -> void:
	fate = fate_
	type = Catalog.fate_to_faction[fate.type]
