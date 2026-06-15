class_name SacrificeData
extends TypeData


signal is_updated
signal is_selected_changed

var abyss: AbyssData
var catena: CatenaData
var tooltip: Bozo.Tooltip = Bozo.Tooltip.SACRIFICE

var type_to_sin: Dictionary
var sins: Array[SinData]
var ambers: Array[AmberData]

var is_selected: bool = false:
	set(value_):
		if value_ != is_selected:
			is_selected = value_
			
			if is_selected:
				abyss.active_sacrifices.append(self)
			else:
				abyss.active_sacrifices.erase(self)
			
			emit_signal("is_selected_changed")


func _init(abyss_: AbyssData, catena_: CatenaData) -> void:
	abyss = abyss_
	catena = catena_
	catena.sacrifice = self

func update_is_selected() -> void:
	is_selected = true

func active() -> void:
	if !is_selected: return
	is_selected = false

func init_ambers() -> void:
	type_to_sin.clear()
	sins.clear()
	ambers.clear()
	
	for cage in catena.cages:
		for _trait in cage.sinner.soul.traits:
			for _sin in _trait.sins:
				add_sin(_sin)
		
		for omen in cage.sinner.soul.doom.omens:
			add_sin(omen.token)
	
	sins.sort_custom(func (a, b): return a.value > b.value)
	
	for _i in Catalog.SACRIFICE_AMBER_COUNT:
		var sin_ = sins[_i]
		var amber_type = Catalog.sin_to_amber[sin_.type]
		var amber = AmberData.new(amber_type, sin_.value)
		ambers.append(amber)
	
	emit_signal("is_updated")

func add_sin(sin_: SinData) -> void:
	var sin_data: SinData
	
	if type_to_sin.has(sin_.type):
		sin_data = type_to_sin[sin_.type]
	else:
		sin_data = SinData.new(sin_.type)
		type_to_sin[sin_.type] = sin_data
		sins.append(sin_data)
	
	sin_data.value += sin_.value
