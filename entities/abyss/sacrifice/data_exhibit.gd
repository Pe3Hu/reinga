class_name ExhibitData
extends TypeData


signal is_updated
signal is_selected_changed

var museum: MuseumData
var cage: CageData
var sinner: SinnerData
var tooltip: Bozo.Tooltip = Bozo.Tooltip.SACRIFICE
var windrose: Bozo.Windrose

var desire: DesireData
var omen: OmenData

var is_selected: bool = false:
	set(value_):
		if value_ != is_selected:
			is_selected = value_
			
			if is_selected:
				museum.active_exhibits.append(self)
			else:
				museum.active_exhibits.erase(self)
			
			emit_signal("is_selected_changed")


func _init(museum_: MuseumData, cage_: CageData, sinner_: SinnerData, windrose_: Bozo.Windrose) -> void:
	museum = museum_
	cage = cage_
	sinner = sinner_
	windrose = windrose_
	
	roll_omen()
	roll_desire()
	emit_signal("is_updated")

func roll_omen() -> void:
	var omen_subtype: Variant
	
	if !museum.omen_options.is_empty():
		omen_subtype = museum.omen_options.pop_back()
	else:
		omen_subtype = Catalog.museum_omens.pick_random()
	
	var omen_type = Catalog.subtype_to_omen[omen_subtype]
	omen = OmenData.new(omen_type)
	omen.subtype = omen_subtype
	
	var sin_type: Bozo.Sin
	
	if !museum.sin_options.is_empty():
		sin_type = museum.sin_options.pop_back()
	else:
		sin_type = Catalog.sins.pick_random()
	
	omen.token.type = sin_type

func roll_desire() -> void:
	var desire_type: Bozo.Desire
	
	match windrose:
		Bozo.Windrose.N:
			desire_type = sinner.dream.primary_desire
		Bozo.Windrose.S:
			desire_type = sinner.dream.secondary_desire
	
	desire = DesireData.new(desire_type)

func update_is_selected() -> void:
	is_selected = true

func fuse_with_sinner() -> void:
	sinner.dream.fuse_desire(desire)
	sinner.soul.doom.fuse_omen(omen)
