class_name CrownData
extends Resource


var trial: TrialData

var seals: Array[SealData]
var type_to_seal: Dictionary


#region init
func _init(trial_: TrialData) -> void:
	trial = trial_
	
	init_seals()

func init_seals() -> void:
	for type in Catalog.seals:
		add_seal(type)

func add_seal(type_: Bozo.Seal) -> void:
	var seal = SealData.new(self, type_)
	seals.append(seal)
	type_to_seal[type_] = seal
#endregion

func apply_attutide_drain(attitude_ : Bozo.Attitude) -> void:
	var seal_type = Catalog.attitude_to_seal[attitude_]
	var seal = type_to_seal[seal_type]
	seal.value += 1
	pass
