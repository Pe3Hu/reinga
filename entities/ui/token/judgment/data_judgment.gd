class_name JudgmentData
extends TokenData


var tooltip: Bozo.Tooltip = Bozo.Tooltip.JUDGMENT
var type: Bozo.Judgment:
	set(value_):
		type = value_
		emit_signal("type_changed")


func _init(type_: Bozo.Judgment, value_: int = 0) -> void:
	type = type_
	value = value_
	always_visible = true
