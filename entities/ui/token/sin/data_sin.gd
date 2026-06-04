class_name SinData
extends TokenData


var tooltip: Bozo.Tooltip = Bozo.Tooltip.SIN
var deal: DealData
var trait_data: TraitData 
var type: Bozo.Sin:
	set(value_):
		type = value_
		emit_signal("type_changed")


func _init(type_: Bozo.Sin, value_: int = 0) -> void:
	type = type_
	value = value_

func apply_value() -> void:
	super.apply_value()
	if deal and value == 0:
		deal.emit_signal("is_completed")
