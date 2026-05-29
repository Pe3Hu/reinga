class_name SinData
extends TokenData


var type: Bozo.Sin:
	set(value_):
		type = value_
		emit_signal("type_changed")


func _init(type_: Bozo.Sin, value_: int = 0) -> void:
	type = type_
	value = value_
