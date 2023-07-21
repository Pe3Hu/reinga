extends MarginContainer


@onready var label = $Label

var dices = null
var min_value = 1
var max_value = 6
var value = null


func roll() -> void:
	Global.rng.randomize()
	value = Global.rng.randi_range(min_value, max_value)
	label.text = str(value)
	dices.values.append(value)
	dices.sum_dice.value += value
