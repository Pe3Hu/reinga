@tool
class_name Progression
extends HBoxContainer


var data: ProgressionData:
	set(value_):
		data = value_
		apply_data_info()

@export var current_label: Label
@export var limit_label: Label


func apply_data_info() -> void:
	data.current_value_changed.connect(_on_current_value_changed)
	data.limit_value_changed.connect(_on_limit_value_changed)
	_on_current_value_changed()
	_on_limit_value_changed()


func _on_current_value_changed():
	current_label.text = str(data.current_value)

func _on_limit_value_changed():
	limit_label.text = str(data.limit_value)
