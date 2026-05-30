class_name FlameData
extends Resource


signal level_changed

var trial: TrialData
var level: int = 1:
	set(value_):
		level = value_
		update_sins()
		emit_signal("level_changed")

var sins: Array[SinData]
var progression: ProgressionData


func _init(trial_: TrialData) -> void:
	trial = trial_
	sins.append_array(trial.claim.sins)
	progression = ProgressionData.new(self)
	progression.type = Bozo.Progression.FLAME

func update_sins() -> void:
	for _i in sins.size():
		var _sin = sins[_i]
		if Catalog.flame_to_claim.has(level):
			_sin.value = Catalog.flame_to_claim[level][_i]
