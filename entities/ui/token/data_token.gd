class_name TokenData
extends TypeData


signal value_changed

var value: int = 0:
	set(value_):
		value = value_
		apply_value()
var always_visible: bool = false


func reset() -> void:
	value = 0

func apply_value() -> void:
	emit_signal("value_changed")
