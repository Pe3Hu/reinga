class_name PostureData
extends TokenData


var type: Bozo.Posture:
	set(value_):
		type = value_
		emit_signal("type_changed")


func _init(type_: Bozo.Posture, value_: int = 0) -> void:
	type = type_
	value = value_
