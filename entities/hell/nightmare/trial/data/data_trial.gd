class_name TrialData
extends Resource


var nightmare: NightmareData
var flame: FlameData
var claim: ClaimData
var type: Bozo.Trial


func _init(nightmare_: NightmareData, type_: Bozo.Trial) -> void:
	nightmare = nightmare_
	type = type_
	claim = ClaimData.new(self)
	flame = FlameData.new(self)
