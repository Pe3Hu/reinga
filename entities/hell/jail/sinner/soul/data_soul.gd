class_name SoulData
extends Resource



var sinner: SinnerData
var fear: TraitData
var repose: TraitData
var horror: TraitData
var guilt: TraitData
var doom: DoomData

var type_to_trait: Dictionary

var traits: Array[TraitData]
var selected_triat_types: Array[Bozo.Trait]


#region init
func _init(sinner_: SinnerData) -> void:
	sinner = sinner_
	init_traits()
	doom = DoomData.new(self)

func init_traits() -> void:
	var trait_options = []
	trait_options.append_array(Catalog.traits)
	trait_options.shuffle()
	
	var combination_index: int = Helper.get_random_key(Catalog.combination_to_weight)
	var rank_options: Array[int]
	
	if Catalog.special_fates.has(sinner.fate.type):
		rank_options.append_array(Catalog.special_rank_combinations[0])
	else:
		rank_options.append_array(Catalog.rank_combinations[combination_index])
	
	rank_options.shuffle()
	
	for _i in rank_options.size():
		var trait_type = trait_options[_i]
		var _rank = rank_options[_i]
		add_trait(trait_type, _rank)
	
	traits = [
		fear,
		horror,
		guilt,
		repose
	]

func add_trait(type_: Bozo.Trait, rank_: int,) -> void:
	match type_:
		Bozo.Trait.FEAR:
			fear = TraitData.new(self, type_, rank_)
			type_to_trait[type_] = fear
		Bozo.Trait.HORROR:
			horror = TraitData.new(self, type_, rank_)
			type_to_trait[type_] = horror
		Bozo.Trait.GUILT:
			guilt = TraitData.new(self, type_, rank_)
			type_to_trait[type_] = guilt
		Bozo.Trait.REPOSE:
			repose = TraitData.new(self, type_, rank_)
			type_to_trait[type_] = repose
#endregion

#region blur
func select_trait(triat_type_: Bozo.Trait) -> void:
	selected_triat_types.append(triat_type_)
	var trait_data = get_trait(triat_type_)
	trait_data.is_selected = true

func reset_blur() -> void:
	for trait_type in selected_triat_types:
		var trait_data = get_trait(trait_type)
		trait_data.is_selected = false
	
	selected_triat_types.clear()

func unblur() -> void:
	selected_triat_types.clear()
	
	for trait_data in traits:
		trait_data.is_selected = true
	
	selected_triat_types.append_array(traits)

func blur() -> void:
	selected_triat_types.clear()
	
	for trait_data in traits:
		trait_data.is_selected = false

func get_trait(trait_type_: Bozo.Trait) -> TraitData:
	var trait_data: TraitData = get(Catalog.trait_to_string[trait_type_])
	return trait_data
#endregion

func reset() -> void:
	for trait_type in traits:
		trait_type.reset()
