class_name GalleryData
extends Resource



var museum: MuseumData
var overlord: OverlordData
var blob: Bozo.Blob

var exhibits: Array[ExhibitData]
var active_exhibits: Array[ExhibitData]

var sinners: Array[SinnerData]

var cage_options: Array[CageData]
var sinner_options: Array[SinnerData]
var desire_options: Array[Bozo.Desire]
var omen_options: Array
var sin_options: Array[Bozo.Sin]


#region init
func _init(museum_: MuseumData, overlord_: OverlordData, blob_: Bozo.Blob) -> void:
	museum = museum_
	overlord = overlord_
	blob = blob_
	
	init_sinners()

func reset_options() -> void:
	sinners.clear()
	desire_options.clear()
	sin_options.clear()
	omen_options.clear()
	sinner_options.clear()
	
	desire_options.append_array(Catalog.desires)
	sin_options.append_array(Catalog.sins)
	omen_options.append_array(Catalog.museum_omens)
	sinner_options = museum.tribunal.get_all_sinners()
	
	desire_options.shuffle()
	sin_options.shuffle()
	omen_options.shuffle()
	sinner_options.shuffle()

func init_sinners() -> void:
	reset_options()
	
	while sinners.size() < Catalog.MUSEUM_CAGE_COUNT:
		pull_sinner()
	
	#sinners.shuffle()
	init_exhibits()

func pull_sinner() -> void:
	if sinner_options.is_empty():
		reset_options()
	
	var sinner = sinner_options.pop_back()
	var is_correct: bool = false
	
	if desire_options.size() > 1:
		is_correct = check_overlap_of_desires(sinner, 2)
	else:
		is_correct = check_overlap_of_desires(sinner, 1)
	
	if is_correct:
		add_sinner(sinner)

func add_sinner(sinner_: SinnerData) -> void:
	sinners.append(sinner_)
	
	if desire_options.has(sinner_.dream.primary_desire):
		desire_options.erase(sinner_.dream.primary_desire)
	
	if desire_options.has(sinner_.dream.secondary_desire):
		desire_options.erase(sinner_.dream.secondary_desire)
	
	if desire_options.is_empty():
		desire_options.append_array(Catalog.desires)

func check_overlap_of_desires(sinner_: SinnerData, limit_: int) -> bool:
	var overlaps = 0
	var primary = sinner_.dream.primary_desire
	var secondary = sinner_.dream.secondary_desire
	
	if desire_options.has(primary):
		overlaps += 1
	
	if desire_options.has(secondary):
		overlaps += 1
	
	return overlaps >= limit_

func init_exhibits() -> void:
	cage_options.append_array(museum.table.cages)
	
	for sinner in sinners:
		var cage = cage_options.pop_back()
		
		for windrose in Catalog.exhibit_windroses:
			add_exhibit(cage, sinner, windrose)

func add_exhibit(cage_: CageData, sinner_: SinnerData, windrose_: Bozo.Windrose) -> void:
	var exhibit = ExhibitData.new(self, cage_, sinner_, windrose_)
	exhibits.append(exhibit)
	omen_options.erase(exhibit.omen.subtype)
	sin_options.erase(exhibit.omen.token.type)
#endregion

func fuse_active_exhibit() -> void:
	var active_exhibit = active_exhibits.pop_back()
	active_exhibit.fuse_with_sinner()
	active_exhibit.is_selected = false

func _on_exhibit_selected(exhibit_: ExhibitData) -> void:
	if !active_exhibits.has(exhibit_):
		exhibit_.is_selected = true
	
	unselect_exhibits()

#region select
func unselect_exhibits() -> void:
	while active_exhibits.size() > 1:
		unselect_exhibit()

func unselect_exhibit() -> void:
	if !active_exhibits.is_empty():
		var exhibit = active_exhibits.pop_front()
		exhibit.is_selected = false

func reset_exhibits() -> void:
	while !active_exhibits.is_empty():
		unselect_exhibit()
#endregion
