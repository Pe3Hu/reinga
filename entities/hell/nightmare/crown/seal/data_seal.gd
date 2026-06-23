class_name SealData
extends Resource


signal value_changed

var crown: CrownData
var tooltip: Bozo.Tooltip
var type: Bozo.Seal:
	set(value_):
		type = value_
		
		if Catalog.seal_to_tooltip.has(type):
			tooltip = Catalog.seal_to_tooltip[type]
var value: int = 0:
	set(value_):
		value = min(value_, Catalog.SEAL_LIMIT)
		emit_signal("value_changed")
		
		if value == Catalog.SEAL_LIMIT:
			crown.trial.nightmare.check_end_game(self)


func _init(crown_: CrownData, type_: Bozo.Seal) -> void:
	crown = crown_
	type = type_
