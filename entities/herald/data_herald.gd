class_name HeraldData
extends Resource


signal decree_is_released

var world: WorldData
var decrees: Array[DecreeData]


func _init(world_: WorldData) -> void:
	world = world_

func test_decrees() -> void:
	var overlords = [
		#world.throne.calthex,
		#world.throne.calthex,
		#world.throne.xalvorr,
		#world.throne.virello,
		#world.throne.calthex,
		#world.throne.xalvorr,
		#world.throne.xalvorr,
		#world.throne.xalvorr,
		#world.throne.virello,
		#world.throne.kharzen,
		#world.throne.kharzen,
		world.throne.sirexil,
	]
	
	var blobs = [
		#Bozo.Blob.PLUS,
		#Bozo.Blob.MINUS,
		#Bozo.Blob.PLUS,
		#Bozo.Blob.MINUS,
		#Bozo.Blob.MINUS,
		#Bozo.Blob.PLUS,
		#Bozo.Blob.PLUS,
		#Bozo.Blob.PLUS,
		#Bozo.Blob.MINUS,
		Bozo.Blob.MINUS,
	]
	
	for _i in overlords.size():
		var overlord = overlords[_i]
		var blob = blobs[_i]
		add_decree(overlord, blob)
	
	release_last_decree()

func add_decree(overlord_: OverlordData, blob_: Bozo.Blob) -> void:
	var decree = DecreeData.new(self, overlord_, blob_)
	decrees.append(decree)

func reinit_same_decrees(overlord_type_: Bozo.Overlord) -> void:
	for decree in decrees:
		if decree.overlord.type == overlord_type_:
			decree.reinit_laws()

func release_last_decree() -> bool:
	if !decrees.is_empty():
		emit_signal("decree_is_released")
		return false
	
	return true
