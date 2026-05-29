class_name AmberData
extends TokenData



var type: Bozo.Amber:
	set(value_):
		value = value_
		emit_signal("type_changed")


func _init(type_: Bozo.Amber, value_: int = 0) -> void:
	type = type_
	value = value_
