class_name TributeData
extends TypeData


var trial: TrialData
var progression: ProgressionData

var tooltip: Bozo.Tooltip = Bozo.Tooltip.TRIBUTE
var type: Bozo.Half = Bozo.Half.LESS:
	set(value_):
		if type != value_:
			type = value_
			emit_signal("type_changed")


#region init
func _init(trial_: TrialData) -> void:
	trial = trial_
	progression = ProgressionData.new(self)
	progression.type = Bozo.Progression.TRIBUTE
	calc_half()

func calc_half() -> void:
	var new_value = 0
	
	for token in trial.claim.sins:
		new_value += token.value
	
	progression.limit_value = floor(new_value * 0.5)
#endregion

func raise_essence() -> void:
	var essence_shift = progression.current_value - progression.limit_value
	
	if progression.current_value >= progression.limit_value * 2:
		essence_shift *= 2
	
	if essence_shift > 0:
		Scope.essence += essence_shift
