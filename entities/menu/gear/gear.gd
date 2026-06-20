@tool
class_name GearTab
extends PanelContainer



@export var buttons: Array[TempoButton]


func _ready() -> void:
	apply_gear_tempo()

func apply_gear_tempo() -> void:
	buttons[Gear.tempo].status = Bozo.Status.ON

func off_buttons(button_: TempoButton) -> void:
	for button in buttons:
		if button != button_:
			button.status = Bozo.Status.OFF
