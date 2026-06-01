class_name TrialData
extends Resource


signal type_changed

var nightmare: NightmareData
var tribute: TributeData
var attitude: AttitudeData
var flame: FlameData
var claim: ClaimData
var type: Bozo.Trial:
	set(value_):
		type = value_
		emit_signal("type_changed")


func _init(nightmare_: NightmareData, type_: Bozo.Trial) -> void:
	nightmare = nightmare_
	type = type_
	
	claim = ClaimData.new(self)
	attitude = AttitudeData.new(self)
	flame = FlameData.new(self)
	tribute = TributeData.new(self)
