class_name TribunalData
extends Resource


var world: WorldData
var hereafter: GyreData = GyreData.new(self, Bozo.Gyre.HEREAFTER)
var actual: GyreData = GyreData.new(self, Bozo.Gyre.ACTUAL)
var bygone: GyreData = GyreData.new(self, Bozo.Gyre.BYGONE)
var gyres: Array[GyreData]
var foreground_sinners: Array[SinnerData]

var left_indexs: Array[int]
var right_indexs: Array[int]
var special_to_index: Dictionary


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
	#for _i in 2:
	#	add_sinner(Bozo.Fate.VILLAIN)

func add_sinner(fate_: Bozo.Fate) -> void:
	var sinner = SinnerData.new(fate_)
	hereafter.sinners.append(sinner)
	sinner.gyre = hereafter
#endregion

#region refill
func refill_actual() -> void:
	if hereafter.sinners.is_empty():
		hereafter.ere.clear()
	
	while actual.sinners.size() < Catalog.GYRE_ACTUAL_SINNER_SIZE:
		use_foreground()
	
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
	var sinner: SinnerData
	if !foreground_sinners.is_empty():
		sinner = foreground_sinners.pop_back()
		actual.sinners.append(sinner)
	else:
		sinner = hereafter.transfer_sinner()
	
	if sinner == null:
		pass
#endregion

func is_enough() -> bool:
	return hereafter.sinners.size() >= Catalog.GYRE_ACTUAL_SINNER_SIZE

func print_total_sinners() -> void:
	var count = foreground_sinners.size()
	
	for gyre in gyres:
		count += gyre.sinners.size()
	
	print(count)
