extends PanelContainer
class_name Cage


var data: CageData:
	set(value_):
		data = value_
		apply_data()

var jail: Jail
var gate: Gate
var contribution: Contribution

@export var sinner: Sinner
@export var cloak: Cloak


func apply_data() -> void:
	sinner.data = data.sinner

func reset() -> void:
	sinner.visible = false
	cloak.visible = false

func switch_side() -> void:
	sinner.visible = !sinner.visible
	cloak.visible = !cloak.visible

func _on_texture_button_pressed() -> void:
	data.table._on_cage_selected(data)
