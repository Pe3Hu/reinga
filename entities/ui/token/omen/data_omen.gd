class_name OmenData
extends TypeData


signal subtype_changed
signal status_changed


var doom: DoomData
var token: SinData
var tooltip: Bozo.Tooltip = Bozo.Tooltip.OMEN
var type: Bozo.Omen:
	set(value_):
		if value_ != type:
			type = value_
			emit_signal("type_changed")
var subtype: Variant:
	set(value_):
		if value_ != subtype:
			subtype = value_
			emit_signal("subtype_changed")
var status: Bozo.Status = Bozo.Status.ON:
	set(value_):
		if value_ != status:
			status = value_
			emit_signal("status_changed")


func _init(doom_: DoomData, type_: Bozo.Omen) -> void:
	doom = doom_
	type = type_
	roll()

func roll() -> void:
	if type == Bozo.Omen.NONE: return
	
	match type:
		Bozo.Omen.FAMILY:
			roll_family()
		Bozo.Omen.DESTINY:
			roll_destiny()
	
	var sin_type = Catalog.sins.pick_random()
	var value = randi_range(2, 8)
	token = SinData.new(sin_type, value)

func roll_destiny() -> void:
	var fate = doom.soul.sinner.fate.type
	var faction = Catalog.fate_to_faction[fate]
	var weights: Dictionary
	
	if !doom.omens.is_empty():
		var origin_omen = doom.omens.front()
		var keys = Catalog.faction_to_destiny[faction].keys()
		
		for _i in range(keys.size()-1, -1, -1):
			var key = keys[_i]
			
			if Catalog.omen_to_omen[origin_omen.subtype].has(key):
				weights[key] = Catalog.faction_to_destiny[faction][key]
	
	if weights.is_empty():
		weights  = Catalog.faction_to_destiny[faction]
	
	subtype = Helper.get_random_key(weights) 

func roll_family() -> void:
	var fate = doom.soul.sinner.fate.type
	var weights: Dictionary
	
	if !doom.omens.is_empty():
		var origin_omen = doom.omens.front()
		var keys = Catalog.fate_to_family[fate].keys()
		
		for _i in range(keys.size()-1, -1, -1):
			var key = keys[_i]
			
			if Catalog.omen_to_omen[origin_omen.subtype].has(key):
				weights[key] = Catalog.fate_to_family[fate][key]
	
	if weights.is_empty():
		weights  = Catalog.fate_to_family[fate]
	
	var family_subtype = Helper.get_random_key(weights) 
	subtype = Catalog.family_to_family[family_subtype]

func update_status() -> void:
	match type:
		Bozo.Omen.DESTINY:
			status = doom.soul.sinner.cage.get_destiny_status(subtype)
		Bozo.Omen.FAMILY:
			status = doom.soul.sinner.cage.get_family_status(subtype)
