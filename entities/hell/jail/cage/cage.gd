@tool
extends PanelContainer
class_name Cage


var data: CageData:
	set(value_):
		data = value_
		apply_data()

var jail: Jail
var gate: Gate
var contribution: Contribution

@export var background: ColorRect
@export var sinner: Sinner
@export var cloak: Cloak


func apply_data() -> void:
	sinner.data = data.sinner

func _on_texture_button_pressed() -> void:
	if gate:
		gate.unblur_all()
	
	if gate:
		data.table._on_cage_gate_selected(data)
	if jail:
		data.table._on_cage_jail_selected(data)
		jail.update_visiblity_omens()
