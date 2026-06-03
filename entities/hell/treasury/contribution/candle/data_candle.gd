class_name CandleData
extends TypeData


signal is_selected_changed

var contribution: ContributionData
var is_selected: bool = false:
	set(value_):
		if is_selected != value_:
			is_selected = value_
			emit_signal("is_selected_changed")

var is_simple: bool = true


func _init(contribution_: ContributionData) -> void:
	contribution = contribution_
	
