class_name ThroneData
extends Resource


var world: WorldData
var overlords: Array[OverlordData]
var type_to_overlord: Dictionary



#region init
func _init(world_: WorldData) -> void:
	world = world_
	
	init_overlords()

func init_overlords() -> void:
	for overlord_type in Catalog.overlords:
		add_overlord(overlord_type)

func add_overlord(type_: Bozo.Overlord) -> void:
	var overlord = OverlordData.new(self, type_)
	overlords.append(overlord)
	type_to_overlord[type_] = overlord
#endregion
