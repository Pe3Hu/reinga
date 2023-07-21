extends MarginContainer


@onready var label = $Label
@onready var bg = $BG


var value = 0


func shift_value(shift_: int) -> void:
	value += shift_
	label.text = str(value)

