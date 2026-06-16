class_name OverlordData
extends Resource


var throne: ThroneData
var type: Bozo.Overlord
var rank: int = 0


func _init(throne_: ThroneData, type_: Bozo.Overlord) -> void:
	throne = throne_
	type = type_
