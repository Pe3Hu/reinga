class_name TributeData
extends TypeData



var trial: TrialData
var type: Bozo.Half = Bozo.Half.LESS:
	set(value_):
		type = value_
		emit_signal("type_changed")
var progression: ProgressionData

func _init(trial_: TrialData) -> void:
	trial = trial_
	progression = ProgressionData.new(self)
	progression.type = Bozo.Progression.TRIBUTE

func calc_half() -> void:
	var new_value = 0
	
	for token in trial.claim.sins:
		new_value += token.value
	
	
	progression.limit_value = floor(new_value*0.5)
