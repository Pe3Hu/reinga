class_name MuseumData
extends Resource


signal gallery_is_released

var world: WorldData
var tribunal: TribunalData
var table: TableData

var gallerys: Array[GalleryData]


func _init(world_: WorldData) -> void:
	world = world_
	table = TableData.new()
	table.museum = self
	tribunal = world.tribunal
	
	test_gallerys()

func test_gallerys() -> void:
	var overlords = [
		#world.throne.calthex,
		#world.throne.xalvorr,
		#world.throne.virello,
		world.throne.kharzen,
		#world.throne.sirexil,
	]
	
	var blobs = [
		Bozo.Blob.PLUS,
		#Bozo.Blob.MINUS,
	]
	
	for _i in overlords.size():
		var overlord = overlords[_i]
		var blob = blobs[_i]
		add_gallery(overlord, blob)
	
	release_last_gallery()

func add_gallery(overlord_: OverlordData, blob_: Bozo.Blob) -> void:
	var gallery = GalleryData.new(self, overlord_, blob_)
	gallerys.append(gallery)

func reinit_same_gallerys(overlord_type_: Bozo.Overlord) -> void:
	for gallery in gallerys:
		if gallery.overlord.type == overlord_type_:
			gallery.reinit_laws()

func release_last_gallery() -> bool:
	if !gallerys.is_empty():
		emit_signal("gallery_is_released")
		return false
	
	return true
