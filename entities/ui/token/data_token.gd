class_name TokenData
extends Resource


signal value_changed
@warning_ignore("unused_signal")
signal type_changed

var value: int = 0:
	set(value_):
		value = value_
		emit_signal("value_changed")


func reset() -> void:
	value = 0
