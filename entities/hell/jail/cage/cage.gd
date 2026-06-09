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

@export var active_background: ColorRect
@export var passive_background: ColorRect
@export var sinner: Sinner
@export var cloak: Cloak


func apply_data() -> void:
	sinner.data = data.sinner

func _on_texture_button_pressed() -> void:
	match Scope.layer:
		Bozo.Layer.HELL:
			if jail and Scope.phase == Bozo.Phase.APPRAISEMENT:
				data.table._on_cage_jail_selected(data)
				jail.update_visiblity_omens()
		Bozo.Layer.GATE:
			if gate:
				gate.unblur_all()
				data.table._on_cage_gate_selected(data)
