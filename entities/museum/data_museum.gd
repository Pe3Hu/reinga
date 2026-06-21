class_name MuseumData
extends Resource


signal gallery_is_released

var world: WorldData
var tribunal: TribunalData
var table: TableData

var gallerys: Array[GalleryData]
var released_gallery: GalleryData


#region init
func _init(world_: WorldData) -> void:
	world = world_
	table = TableData.new()
	table.museum = self
	tribunal = world.tribunal

func add_gallery(overlord_: OverlordData, blob_: Bozo.Blob) -> void:
	var gallery = GalleryData.new(self, overlord_, blob_)
	gallerys.append(gallery)

func begin_session() -> bool:
	end_session()
	return release_last_gallery()

func end_session() -> void:
	tribunal.reserved_sinners.clear()
	released_gallery = null
	
	for gallery in gallerys:
		gallery.reset_lineup()
	
	for cage in table.cages:
		cage.sinner = null

func release_last_gallery() -> bool:
	while !gallerys.is_empty():
		var gallery_data = gallerys.pop_back()
		if gallery_data.prepare():
			released_gallery = gallery_data
			emit_signal("gallery_is_released")
			return false
		if tribunal.count_available_for_gallery() == 0:
			gallerys.clear()
			break
		push_warning("GalleryData skipped: incomplete lineup")
	
	released_gallery = null
	return true
#endregion
