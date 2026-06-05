class_name OmenData
extends TypeData


signal subtype_changed
signal status_changed


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


func _init(type_: Bozo.Omen) -> void:
	type = type_
	roll()

func roll() -> void:
	if type == Bozo.Omen.NONE: return
	roll_destiny()
	roll_family()
	var sin_type = Catalog.sins.pick_random()
	var value = randi_range(2, 8)
	token = SinData.new(sin_type, value)

func roll_destiny() -> void:
	if type == Bozo.Omen.FAMILY: return
	var fate = Catalog.fates.pick_random()
	var faction = Catalog.fate_to_faction[fate]
	subtype =  Helper.get_random_key(Catalog.faction_to_destiny[faction]) 

func roll_family() -> void:
	if type == Bozo.Omen.DESTINY: return
	var fate = Catalog.fates.pick_random()
	var family_subtype = Helper.get_random_key(Catalog.fate_to_family[fate]) 
	subtype = Catalog.family_to_family[family_subtype]
