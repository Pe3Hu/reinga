extends MarginContainer


@onready var worktops = $HBox/Worktops
@onready var indicators = $HBox/Indicators

var team = null
var skills = []
var specialization = null
var initiative = 1


func _ready() -> void:
	init_wortops()
	indicators.label.text = specialization
	indicators.sinner = self


func init_wortops() -> void:
	var n = 2
	
	for _i in n:
		var worktop = Global.scene.worktop.instantiate()
		worktop.sinner = self
		worktops.add_child(worktop)


func fills_dicespots() -> void:
	var dices = team.arena.dices
	var appropriate_dicespots = []
	
	for worktop in worktops.get_children():
		for dicespot in worktop.dicespots.get_children():
			if !dicespot.active and dices.sum_dice.value == dicespot.sum:
				appropriate_dicespots.append(dicespot)
	
	if appropriate_dicespots.is_empty():
		fill_ultimate()
	else:
		var dicespot = appropriate_dicespots.pick_random()
		dicespot.energize()
		
		for dicespot_ in appropriate_dicespots:
			pass
		
		var readymades = dicespot.workstop.get_readymade_skills()
		
		if !readymades.is_empty():
			choose_skill(readymades)


func fill_ultimate() -> void:
	var value = team.arena.dices.values.pick_random()
	indicators.ultimate.fill_cell(value)


func choose_skill(readymades_: Array) -> void:
	var data = readymades_.pick_random()
	data.worktop.activate_skill(data.axis, data.skill)
