class_name TribunalData
extends Resource


var world: WorldData
var hereafter: GyreData = GyreData.new(self, Bozo.Gyre.HEREAFTER)
var actual: GyreData = GyreData.new(self, Bozo.Gyre.ACTUAL)
var bygone: GyreData = GyreData.new(self, Bozo.Gyre.BYGONE)
var gyres: Array[GyreData]
var foreground_sinners: Array[SinnerData]
var reserved_sinners: Array[SinnerData]

var left_indexs: Array[int]
var right_indexs: Array[int]
var special_to_index: Dictionary

var enhancement_to_sinner: Dictionary


#region init
func _init(world_: WorldData) -> void:
	world = world_
	
	update_gyre_fol()
	update_gyre_ere()
	init_fates()
	
	gyres = [
		hereafter,
		actual,
		bygone,
	]

func update_gyre_fol() -> void:
	hereafter.fol = actual
	actual.fol = bygone
	bygone.fol = hereafter

func update_gyre_ere() -> void:
	hereafter.ere = bygone
	actual.ere = hereafter
	bygone.ere = actual

func init_fates() -> void:
	for faction in Catalog.factions:
		var options: Array[Bozo.Fate]
		options.append_array(Catalog.faction_to_fate[faction])
		options.shuffle()
		var counts = [2, 2, 1, 1]
		
		while !counts.is_empty():
			var count = counts.pop_back()
			var fate = options.pop_back()
			
			for _i in count:
				add_sinner(fate)
	
	hereafter.sinners.shuffle()

func add_sinner(fate_: Bozo.Fate) -> void:
	var sinner = SinnerData.new(fate_)
	hereafter.sinners.append(sinner)
	sinner.gyre = hereafter
	
	var enhancement = sinner.soul.doom.omens.size()
	
	if !enhancement_to_sinner.has(enhancement):
		enhancement_to_sinner[enhancement] = []
	
	enhancement_to_sinner[enhancement].append(sinner)
#endregion

#region refill
func refill_actual() -> void:
	if hereafter.sinners.is_empty():
		hereafter.ere.clear()
	
	while actual.sinners.size() < Catalog.GYRE_ACTUAL_SINNER_SIZE:
		use_foreground()
	
	merge_foreground_to_hereafter()
	actual.sinners.shuffle()
	apply_special_rules()

func refill_loop() -> void:
	actual.null_sinner_bug_update()

func apply_special_rules() -> void:
	special_to_index.clear()
	trust_on_right()
	hope_on_left()
	sort_special_fate()

func trust_on_right() -> void:
	right_indexs.clear()
	var trusts = actual.sinners.filter(func (a): return Catalog.trust_fates.has(a.fate.type))
	
	if !trusts.is_empty():
		right_indexs.append_array(Catalog.right_indexs)
		right_indexs.shuffle()
		
		while !trusts.is_empty() and !right_indexs.is_empty():
			var trust = trusts.pop_back()
			var index = right_indexs.pop_back()
			set_special_index(trust, index)

func hope_on_left() -> void:
	left_indexs.clear()
	var hopes = actual.sinners.filter(func (a): return Catalog.hope_fates.has(a.fate.type))
	
	if !hopes.is_empty():
		left_indexs.append_array(Catalog.left_indexs)
		left_indexs.shuffle()
		
		while !hopes.is_empty() and !left_indexs.is_empty():
			var hope = hopes.pop_back()
			var index = left_indexs.pop_back()
			set_special_index(hope, index)

func set_special_index(special_: Variant, index_: int) -> void: 
	special_to_index[special_] = index_
	
	if left_indexs.has(index_):
		left_indexs.erase(index_)
	
	if right_indexs.has(index_):
		right_indexs.erase(index_)

func sort_special_fate() -> void:
	if special_to_index.keys().is_empty(): return
	var options: Array[int]
	options.append_array(Catalog.indexs)
	
	for special in special_to_index:
		var index = special_to_index[special]
		options.erase(index)
	
	for sinner in actual.sinners:
		if !special_to_index.has(sinner):
			var index = options.pop_back()
			special_to_index[sinner] = index
	
	actual.sinners.sort_custom(func (a, b): return special_to_index[a] < special_to_index[b])

func use_foreground() -> void:
	var sinner = hereafter.transfer_sinner()
	
	if sinner == null:
		pass

func add_gate_sinner(sinner_: SinnerData) -> void:
	foreground_sinners.append(sinner_)
	
	#sinner_.gyre = hereafter
	
	var enhancement = sinner_.soul.doom.omens.size()
	
	if !enhancement_to_sinner.has(enhancement):
		enhancement_to_sinner[enhancement] = []
	
	enhancement_to_sinner[enhancement].append(sinner_)

func remove_sinner(sinner_: SinnerData) -> void:
	_remove_from_enhancement_index(sinner_)
	reserved_sinners.erase(sinner_)
	
	if foreground_sinners.has(sinner_):
		foreground_sinners.erase(sinner_)
		return
	
	for gyre in gyres:
		if gyre.sinners.has(sinner_):
			gyre.sinners.erase(sinner_)
			sinner_.gyre = null
			return

func _remove_from_enhancement_index(sinner_: SinnerData) -> void:
	var enhancement = sinner_.soul.doom.omens.size()
	
	if !enhancement_to_sinner.has(enhancement):
		return
	
	enhancement_to_sinner[enhancement].erase(sinner_)
	
	if enhancement_to_sinner[enhancement].is_empty():
		enhancement_to_sinner.erase(enhancement)
#endregion

func merge_foreground_to_hereafter() -> void:
	if foreground_sinners.is_empty(): return
	
	for sinner in foreground_sinners:
		sinner.gyre = hereafter
	
	hereafter.sinners.append_array(foreground_sinners)
	foreground_sinners.clear()

func count_draw_pile() -> int:
	return hereafter.sinners.size() + foreground_sinners.size()

func is_enough() -> bool:
	return count_draw_pile() >= Catalog.GYRE_ACTUAL_SINNER_SIZE

func print_total_sinners() -> void:
	var count = foreground_sinners.size()
	
	for gyre in gyres:
		count += gyre.sinners.size()
	
	print(count)

func count_available_for_gallery() -> int:
	var count = 0
	
	for gyre in gyres:
		for sinner in gyre.sinners:
			if is_available_for_gallery(sinner):
				count += 1
	
	return count

func get_unreserved_sinners(log_: bool = false) -> Array[SinnerData]:
	var sinners: Array[SinnerData]
	
	for gyre in gyres:
		sinners.append_array(gyre.sinners)
	
	sinners = sinners.filter(func (a): return is_available_for_gallery(a))
	if log_:
		print(["any", sinners.size()])
	return sinners

func is_available_for_gallery(sinner_: SinnerData) -> bool:
	return !reserved_sinners.has(sinner_) \
		and sinner_.soul.doom.omens.size() < Catalog.DOOM_OMEN_LIMIT

func reserve_sinner(sinner_: SinnerData) -> void:
	if !reserved_sinners.has(sinner_):
		reserved_sinners.append(sinner_)

func get_min_enhancemented_sinners(shift_: int = 0, log_: bool = false) -> Array[SinnerData]:
	var sinners: Array[SinnerData]
	if enhancement_to_sinner.is_empty():
		return sinners
	
	var min_enhancemented = enhancement_to_sinner.keys().min() + shift_
	
	if min_enhancemented >= Catalog.DOOM_OMEN_LIMIT:
		return sinners
	
	if !enhancement_to_sinner.has(min_enhancemented):
		return sinners
	
	sinners.append_array(enhancement_to_sinner[min_enhancemented])
	sinners = sinners.filter(func (a): return is_available_for_gallery(a))
	if log_:
		print(["min", min_enhancemented, sinners.size()])
	return sinners

func get_max_enhancemented_sinners(shift_: int = 0) -> Array[SinnerData]:
	var sinners: Array[SinnerData]
	var eligible_keys: Array = enhancement_to_sinner.keys().filter(
		func (a): return a < Catalog.DOOM_OMEN_LIMIT
	)
	
	if eligible_keys.is_empty():
		return sinners
	
	var max_enhancemented = eligible_keys.max() - shift_
	
	if max_enhancemented < 0 or !enhancement_to_sinner.has(max_enhancemented):
		return sinners
	
	sinners.append_array(enhancement_to_sinner[max_enhancemented])
	sinners = sinners.filter(func (a): return is_available_for_gallery(a))
	print(["max", max_enhancemented, sinners.size()])
	return sinners

func get_min_enhancemented_index() -> int:
	return enhancement_to_sinner.keys().min()

func investment() -> void:
	actual.clear()

func get_sinners_for_abyss() -> Array[SinnerData]:
	var sinners: Array[SinnerData]
	sinners.append_array(foreground_sinners)
	sinners.append_array(hereafter.sinners)
	sinners.append_array(bygone.sinners)
	
	if !actual.sinners.is_empty():
		sinners.append_array(actual.sinners)
	
	return sinners
