@tool
class_name TokenJudgment
extends Token


func _ready() -> void:
	always_visible = true

func apply_data_info() -> void:
	super.apply_data_info()
	data.type_changed.connect(_on_type_changed)
	_on_type_changed()

func _on_type_changed() -> void:
	pass
