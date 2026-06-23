class_name CrownData
extends Resource


var trial: TrialData

var seals: Array[SealData]
var type_to_seal: Dictionary


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
