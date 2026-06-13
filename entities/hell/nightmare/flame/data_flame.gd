class_name FlameData
extends Resource


signal level_changed

var trial: TrialData
var tax: TaxData
var tooltip: Bozo.Tooltip = Bozo.Tooltip.FLAME
var level: int = 1:
	set(value_):
		if Catalog.flame_to_heat.has(value_):
			level = value_
			progression.limit_value = Catalog.flame_to_heat[level]
			tax.update_sins()
			emit_signal("level_changed")

var sins: Array[SinData]
var progression: ProgressionData


#region init
func _init(trial_: TrialData) -> void:
	trial = trial_
	
	tax = TaxData.new(self)
	init_progression()

func init_progression() -> void:
	progression = ProgressionData.new(self)
	progression.type = Bozo.Progression.FLAME
	progression.limit_value = Catalog.flame_to_heat[level]
#endregion
