class_name SinnerData
extends Resource


@export var fate: Bozo.Fate
@export var faction: Bozo.Faction

@export var fear: TraitData
@export var repose: TraitData
@export var horror: TraitData
@export var guilt: TraitData

var gyre: GyreData


func _init(fate_: Bozo.Fate) -> void:
	fate = fate_
	faction = Catalog.fate_to_faction[fate]
	
	init_traits()

func init_traits() -> void:
	var trait_options = []
	trait_options.append_array(Catalog.traits)
	trait_options.shuffle()
	
	var rank_options = Helper.get_random_key(Catalog.rank_to_weight)
	rank_options.shuffle()
	
	for _i in rank_options.size():
		var _trait = trait_options[_i]
		var _rank = rank_options[_i]
		add_trait(_trait, _rank)

func add_trait(type_: Bozo.Triat, rank_: int,) -> void:
	match type_:
		Bozo.Triat.FEAR:
			fear = TraitData.new(self, type_, rank_)
		Bozo.Triat.HORROR:
			horror = TraitData.new(self, type_, rank_)
		Bozo.Triat.GUILT:
			guilt = TraitData.new(self, type_, rank_)
		Bozo.Triat.REPOSE:
			repose = TraitData.new(self, type_, rank_)
