extends MarginContainer


@onready var label = $Label
@onready var bg = $BG

var workstop = null
var grid = null
var permutation = null
var sum = null
var skills = {}
var active = false


func set_permutation(permutation_: int) -> void:
	if permutation != 0:
		workstop.skills.x[skills.x].multiplication /= permutation
		workstop.skills.y[skills.y].multiplication /= permutation
	
	permutation = permutation_
	workstop.skills.x[skills.x].multiplication *= permutation
	workstop.skills.y[skills.y].multiplication *= permutation
	label.text = str(permutation)


func set_sum() -> void:
	sum = Global.dict.permutation.sum[permutation].pick_random()
	label.text = str(sum)


func energize() -> void:
	active = true
	bg.visible = true


func deenergize() -> void:
	active = false
	bg.visible = false
