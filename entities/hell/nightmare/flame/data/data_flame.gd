class_name FlameData
extends Resource


var trial: TrialData
var level: int:
	set(value_):
		level = value_
		update_sins()
var sins: Array[SinData]


func _init(trial_: TrialData) -> void:
	trial = trial_
	sins.append_array(trial.claim.sins)

func update_sins() -> void:
	for _i in sins.size():
		var _sin = sins[_i]
		_sin.value = Catalog.flame_to_claim[level][_i]
