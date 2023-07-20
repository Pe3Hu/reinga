extends MarginContainer


@onready var label = $Label

var min_value = 1
var max_value = 6


func roll() -> void:
	Global.rng.randomize()
	var value = Global.rng.randi_range(min_value, max_value)
	label.text = str(value)
