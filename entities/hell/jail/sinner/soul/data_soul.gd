class_name SoulData
extends Resource


var sinner: SinnerData
var fear: TraitData
var repose: TraitData
var horror: TraitData
var guilt: TraitData

var type_to_trait: Dictionary


func _init(sinner_: SinnerData) -> void:
	sinner = sinner_
	init_traits()

func init_traits() -> void:
	var trait_options = []
	trait_options.append_array(Catalog.traits)
	trait_options.shuffle()
	
	var combination_index = Helper.get_random_key(Catalog.combination_to_weight)
	var rank_options = Catalog.rank_combinations[combination_index]
	
	rank_options.shuffle()
	
	for _i in rank_options.size():
		var _trait = trait_options[_i]
		var _rank = rank_options[_i]
		add_trait(_trait, _rank)

func add_trait(type_: Bozo.Triat, rank_: int,) -> void:
	match type_:
		Bozo.Triat.FEAR:
			fear = TraitData.new(self, type_, rank_)
			type_to_trait[type_] = fear
		Bozo.Triat.HORROR:
			horror = TraitData.new(self, type_, rank_)
			type_to_trait[type_] = horror
		Bozo.Triat.GUILT:
			guilt = TraitData.new(self, type_, rank_)
			type_to_trait[type_] = guilt
		Bozo.Triat.REPOSE:
			repose = TraitData.new(self, type_, rank_)
			type_to_trait[type_] = repose
