class_name TrialData
extends Resource


signal type_changed

var nightmare: NightmareData
var tribute: TributeData
var attitude: AttitudeData
var flame: FlameData
var claim: ClaimData
var tooltip: Bozo.Tooltip = Bozo.Tooltip.TRIAL
var overlord: OverlordData
var type: Bozo.Trial:
	set(value_):
		type = value_
		emit_signal("type_changed")


func _init(nightmare_: NightmareData, type_: Bozo.Trial) -> void:
	nightmare = nightmare_
	type = type_
	overlord = nightmare.hell.world.throne.type_to_overlord[Catalog.trial_to_overlord[type]]
	
	claim = ClaimData.new(self)
	attitude = AttitudeData.new(self)
	flame = FlameData.new(self)
	tribute = TributeData.new(self)
