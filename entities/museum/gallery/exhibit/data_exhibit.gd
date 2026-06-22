class_name ExhibitData
extends TypeData


signal is_updated
signal is_selected_changed

var gallery: GalleryData
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
				gallery.active_exhibits.append(self)
			else:
				gallery.active_exhibits.erase(self)
			
			emit_signal("is_selected_changed")


func _init(gallery_: GalleryData, cage_: CageData, sinner_: SinnerData, windrose_: Bozo.Windrose) -> void:
	gallery = gallery_
	cage = cage_
	sinner = sinner_
	windrose = windrose_
	
	roll_omen()
	roll_desire()
	emit_signal("is_updated")

func roll_omen() -> void:
	if sinner.soul.doom.omens.size() >= Catalog.DOOM_OMEN_LIMIT:
		push_error("ExhibitData.roll_omen: sinner doom is full for gallery")
		roll_from_options()
	elif sinner.soul.doom.omens.is_empty():
		roll_from_options()
	else:
		roll_from_doom()
	
	roll_omen_sin()
	
func roll_from_options() -> void:
	var omen_subtype: Variant
	
	if !gallery.omen_options.is_empty():
		omen_subtype = gallery.omen_options.pop_back()
	else:
		omen_subtype = Catalog.gallery_omens.pick_random()
	
	var omen_type = Catalog.subtype_to_omen[omen_subtype]
	omen = OmenData.new(omen_type)
	omen.subtype = omen_subtype

func roll_omen_sin() -> void:
	var sin_type: Bozo.Sin
	
	if !gallery.sin_options.is_empty():
		sin_type = gallery.sin_options.pop_back()
	else:
		sin_type = Catalog.sins.pick_random()
	
	omen.token.type = sin_type
	
	if gallery.blob == Bozo.Blob.MINUS:
		omen.token.value *= -1

func roll_from_doom() -> void:
	if sinner.soul.doom.omens.is_empty(): return
	if sinner.soul.doom.omens.size() >= Catalog.DOOM_OMEN_LIMIT:
		push_error("ExhibitData.roll_from_doom: sinner doom is full for gallery")
		return
	
	var doom_omen = sinner.soul.doom.omens.front()
	var subtype_options = Catalog.omen_to_omen[doom_omen.subtype].duplicate()
	#subtype_options = subtype_options.filter(func (a): Catalog.doom_omens.has(a))
	var omen_subtype = subtype_options.pick_random()
	var omen_type = Catalog.subtype_to_omen[omen_subtype]
	omen = OmenData.new(omen_type)
	omen.subtype = omen_subtype

func roll_desire() -> void:
	var desire_type: Bozo.Desire
	
	match windrose:
		Bozo.Windrose.N:
			desire_type = sinner.dream.primary_desire
		Bozo.Windrose.S:
			desire_type = sinner.dream.secondary_desire
	
	desire = DesireData.new(desire_type)

#func update_is_selected() -> void:
	#is_selected = true

func fuse_with_sinner() -> void:
	var tribunal = sinner.gyre.tribunal
	var enhancement = sinner.soul.doom.omens.size()
	tribunal.enhancement_to_sinner[enhancement].erase(sinner)
	
	if tribunal.enhancement_to_sinner[enhancement].is_empty():
		tribunal.enhancement_to_sinner.erase(enhancement)
	
	sinner.dream.fuse_desire(desire)
	sinner.soul.doom.fuse_omen(omen)
	
	enhancement += 1
	
	if !tribunal.enhancement_to_sinner.has(enhancement):
		tribunal.enhancement_to_sinner[enhancement] = []
	
	tribunal.enhancement_to_sinner[enhancement].append(sinner)
	sinner.notify_fused()
