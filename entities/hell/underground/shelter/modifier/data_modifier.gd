class_name ModifierData
extends Resource


signal type_changed
signal value_changed

var type: Bozo.Modifier:
	set(value_):
		type = value_
		emit_signal("type_changed")
var value: int:
	set(value_):
		value = value_
		emit_signal("value_changed")
