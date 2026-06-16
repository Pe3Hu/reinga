class_name ThroneData
extends Resource


var world: WorldData

var calthex: OverlordData
var kharzen: OverlordData
var virello: OverlordData
var xalvorr: OverlordData
var sirexil: OverlordData
var marvone: OverlordData

var overlords: Array[OverlordData]
var type_to_overlord: Dictionary



#region init
func _init(world_: WorldData) -> void:
	world = world_
	
	init_overlords()

func init_overlords() -> void:
	for overlord_type in Catalog.overlords:
		add_overlord(overlord_type)
	
	add_overlord(Bozo.Overlord.MARVONE)

func add_overlord(type_: Bozo.Overlord) -> void:
	var overlord = OverlordData.new(self, type_)
	overlords.append(overlord)
	type_to_overlord[type_] = overlord
	set(Catalog.overlord_to_string[type_], overlord)
#endregion
