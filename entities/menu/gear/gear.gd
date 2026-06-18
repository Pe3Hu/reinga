@tool
class_name GearTab
extends PanelContainer



@export var buttons: Array[TempoButton]


func _ready() -> void:
	%Slow.status = Bozo.Status.ON

func off_buttons(button_: TempoButton) -> void:
	for button in buttons:
		if button != button_:
			button.status = Bozo.Status.OFF
		
			pass
