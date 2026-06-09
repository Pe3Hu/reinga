class_name FlameData
extends Resource


signal level_changed

var trial: TrialData
var tooltip: Bozo.Tooltip = Bozo.Tooltip.FLAME
var level: int = 1:
	set(value_):
		if Catalog.flame_to_heat.has(value_):
			level = value_
			progression.limit_value = Catalog.flame_to_heat[level]
			update_sins()
			emit_signal("level_changed")

var sins: Array[SinData]
var progression: ProgressionData


#region init
func _init(trial_: TrialData) -> void:
	trial = trial_
	
	init_progression()
	init_sins()

func init_progression() -> void:
	progression = ProgressionData.new(self)
	progression.type = Bozo.Progression.FLAME
	progression.limit_value = Catalog.flame_to_heat[level]

func init_sins() -> void:
	for sin_data in trial.claim.sins:
		add_sin(sin_data)

func add_sin(donor_data_: SinData) -> void:
	var sin_data = SinData.new(donor_data_.type, donor_data_.value)
	sins.append(sin_data)
#endregion

func update_sins() -> void:
	for _i in sins.size():
		var _sin = sins[_i]
		if Catalog.flame_to_claim.has(level):
			_sin.value = Catalog.flame_to_claim[level][_i]

func swap_sin_type(old_type_: Bozo.Sin, new_type_: Bozo.Sin) -> void:
	for _sin in sins:
		if _sin.type == old_type_:
			_sin.type = new_type_
			return
