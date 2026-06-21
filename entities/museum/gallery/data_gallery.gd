class_name GalleryData
extends Resource


var museum: MuseumData
var overlord: OverlordData
var blob: Bozo.Blob

var exhibits: Array[ExhibitData]
var active_exhibits: Array[ExhibitData]

var sinners: Array[SinnerData]

var is_prepared: bool = false
var sinner_options: Array[SinnerData]
var desire_options: Array[Bozo.Desire]
var omen_options: Array
var sin_options: Array[Bozo.Sin]

var relaxation_counter: int = 3
var desire_bans: Array[Bozo.Desire]
var enhancemented_index: int = 0

# true = get_max_enhancemented_sinners for late-game contradiction testing
const SIMULATE_LATE_ENHANCEMENT := false


#region init
func _init(museum_: MuseumData, overlord_: OverlordData, blob_: Bozo.Blob) -> void:
	museum = museum_
	overlord = overlord_
	blob = blob_

func reset_lineup() -> void:
	is_prepared = false
	sinners.clear()
	exhibits.clear()
	active_exhibits.clear()
	relaxation_counter = 3
	desire_bans.clear()
	enhancemented_index = 0

func prepare() -> bool:
	if is_prepared:
		return true
	if !init_sinners():
		reset_lineup()
		return false
	is_prepared = true
	return true

func is_pool_scarce() -> bool:
	return museum.tribunal.count_available_for_gallery() <= Catalog.MUSEUM_CAGE_COUNT - sinners.size()

func reset_options(is_relaxed_: bool = false) -> void:
	desire_bans = [Bozo.Desire.NONE]
	relaxation_counter -= 1
	enhancemented_index = 0
	
	desire_options.clear()
	sin_options.clear()
	omen_options.clear()
	sinner_options.clear()
	
	desire_options.append_array(Catalog.desires)
	sin_options.append_array(Catalog.sins)
	omen_options.append_array(Catalog.museum_omens)
	
	refill_sinner_options(is_relaxed_)
	
	desire_options.shuffle()
	sin_options.shuffle()
	omen_options.shuffle()
	sinner_options.shuffle()


func refill_sinner_options(is_relaxed_: bool = false) -> void:
	var needed = Catalog.MUSEUM_CAGE_COUNT - sinners.size()
	var tier_cap = Catalog.DOOM_OMEN_LIMIT
	
	while sinner_options.size() < needed and enhancemented_index < tier_cap:
		var _sinner_options: Array[SinnerData]
		
		if SIMULATE_LATE_ENHANCEMENT:
			_sinner_options = museum.tribunal.get_max_enhancemented_sinners(enhancemented_index)
		else:
			_sinner_options = museum.tribunal.get_min_enhancemented_sinners(enhancemented_index)
		
		if is_relaxed_ and !is_pool_scarce():
			_sinner_options = _sinner_options.filter(func (a): return a.dream.on_overlord_duty(overlord))
			_sinner_options = _sinner_options.filter(func (a): return !desire_bans.has(a.dream.get_not_overlord_desire(overlord)))
		
		_sinner_options = _sinner_options.filter(func (a): return !sinners.has(a))
		sinner_options.append_array(_sinner_options)
		enhancemented_index += 1

func init_sinners() -> bool:
	sinners.clear()
	exhibits.clear()
	relaxation_counter = 3
	desire_bans.clear()
	enhancemented_index = 0
	
	var available = museum.tribunal.count_available_for_gallery()
	if available == 0:
		return false
	if available <= Catalog.MUSEUM_CAGE_COUNT:
		fill_lineup_fallback()
		return try_complete_lineup()
	
	reset_options()
	
	while sinners.size() < Catalog.MUSEUM_CAGE_COUNT:
		if museum.tribunal.count_available_for_gallery() == 0:
			break
		
		if relaxation_counter < 0:
			init_relaxed_sinners()
			break
		
		var size_before = sinners.size()
		pull_sinner()
		
		if sinners.size() == size_before:
			if relaxation_counter >= 0:
				reset_options()
			else:
				init_relaxed_sinners()
				break
	
	return try_complete_lineup()

func try_complete_lineup() -> bool:
	if sinners.size() < Catalog.MUSEUM_CAGE_COUNT:
		fill_lineup_fallback()
	if sinners.is_empty():
		return false
	init_exhibits()
	return true

func fill_lineup_fallback() -> void:
	for shift in Catalog.DOOM_OMEN_LIMIT:
		if sinners.size() >= Catalog.MUSEUM_CAGE_COUNT:
			return
		var _options = museum.tribunal.get_min_enhancemented_sinners(shift)
		_options.shuffle()
		for sinner in _options:
			if sinners.size() >= Catalog.MUSEUM_CAGE__optionsCOUNT:
				return
			if !sinners.has(sinner):
				sinners.append(sinner)
	
	var options = museum.tribunal.get_unreserved_sinners(true)
	options.shuffle()
	for sinner in options:
		if sinners.size() >= Catalog.MUSEUM_CAGE_COUNT:
			break
		if !sinners.has(sinner):
			sinners.append(sinner)

func pull_sinner(is_relaxed: bool = false, attempts_: int = 0) -> void:
	if attempts_ > 64:
		push_error("GalleryData.pull_sinner: exceeded attempts")
		return
	if sinners.size() >= Catalog.MUSEUM_CAGE_COUNT:
		return
	if !is_relaxed:
		if sinner_options.is_empty():
			if relaxation_counter >= 0:
				reset_options()
				pull_sinner(false, attempts_ + 1)
			else:
				init_relaxed_sinners()
			return
		
		var sinner = sinner_options.pop_back()
		
		if !museum.tribunal.is_available_for_gallery(sinner) or sinners.has(sinner):
			pull_sinner(false, attempts_ + 1)
			return
		
		var overlap_limit = 2 if desire_options.size() > 1 else 1
		
		if check_overlap_of_desires(sinner, overlap_limit) or is_pool_scarce():
			add_sinner(sinner)
		else:
			pull_sinner(false, attempts_ + 1)
	else:
		if sinner_options.is_empty():
			fill_lineup_fallback()
			return
		
		var sinner = sinner_options.pop_back()
		
		if !museum.tribunal.is_available_for_gallery(sinner) or sinners.has(sinner):
			pull_sinner(true, attempts_ + 1)
			return
		
		add_relaxed_sinner(sinner)

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
	for _i in museum.table.cages.size():
		var cage = museum.table.cages[_i]
		if _i >= sinners.size():
			cage.sinner = null
			continue
		var sinner = sinners[_i]
		for windrose in Catalog.exhibit_windroses:
			add_exhibit(cage, sinner, windrose)
	
	for sinner in sinners:
		museum.tribunal.reserve_sinner(sinner)

func add_exhibit(cage_: CageData, sinner_: SinnerData, windrose_: Bozo.Windrose) -> void:
	cage_.sinner = sinner_
	
	var exhibit = ExhibitData.new(self, cage_, sinner_, windrose_)
	exhibits.append(exhibit)
	
	if omen_options.has(exhibit.omen.subtype):
		omen_options.erase(exhibit.omen.subtype)
	
	if sin_options.has(exhibit.omen.token.type):
		sin_options.erase(exhibit.omen.token.type)

func init_relaxed_sinners() -> void:
	if !is_pool_scarce():
		reset_options(true)
	
	while sinners.size() < Catalog.MUSEUM_CAGE_COUNT:
		if museum.tribunal.count_available_for_gallery() == 0:
			break
		
		var size_before = sinners.size()
		pull_sinner(true)
		
		if sinners.size() == size_before:
			fill_lineup_fallback()
			if sinners.size() == size_before:
				break

func add_relaxed_sinner(sinner_: SinnerData) -> void:
	sinners.append(sinner_)
	var not_overlord_desire = sinner_.dream.get_not_overlord_desire(overlord)
	desire_bans.append(not_overlord_desire)
	
	sinner_options = sinner_options.filter(func (a): return !desire_bans.has(a.dream.get_not_overlord_desire(overlord)))
	
	refill_sinner_options(true)
	
	if sinner_options.size() < Catalog.MUSEUM_CAGE_COUNT - sinners.size():
		sinner_options = museum.tribunal.get_unreserved_sinners()
#endregion

func fuse_active_exhibit() -> void:
	if active_exhibits.is_empty():
		return
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
