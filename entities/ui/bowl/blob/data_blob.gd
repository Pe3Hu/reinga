class_name BlobData
extends Resource


signal is_active_changed

var bowl: BowlData
var is_active: bool = false:
	set(value_):
		is_active = value_
		emit_signal("is_active_changed")


func _init(bowl_: BowlData) -> void:
	bowl = bowl_
