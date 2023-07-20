extends MarginContainer


@onready var label = $Label
@onready var bg = $BG

var workstop = null
var grid = null
var value = null
var skill = {}


func set_value(value_: int) -> void:
	if value != 0:
		workstop.skills.x[skill.x].multiplication /= value
		workstop.skills.y[skill.y].multiplication /= value
	
	value = value_
	workstop.skills.x[skill.x].multiplication *= value
	workstop.skills.y[skill.y].multiplication *= value
	label.text = str(value)
