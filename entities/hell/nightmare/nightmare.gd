class_name Nightmare
extends PanelContainer


var data: NightmareData = NightmareData.new()

@export var trials: Array[Trial]


func _ready() -> void:
	for _i in data.trials.size():
		var trial = trials[_i]
		trial.data = data.trials[_i]
