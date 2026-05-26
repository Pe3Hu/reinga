class_name Soul
extends MarginContainer


@export var sinner: Sinner

var traits: Array[Trait]

@export var fear: Trait
@export var horror: Trait
@export var guilt: Trait
@export var repose: Trait

var selected_triats: Array[Bozo.Triat]
var type: Bozo.Tooltip = Bozo.Tooltip.SOUL


func _ready() -> void:
	traits = [
		fear,
		horror,
		guilt,
		repose
	]

func connect_datas() -> void:
	fear.data = sinner.data.fear
	horror.data = sinner.data.horror
	guilt.data = sinner.data.guilt
	repose.data = sinner.data.repose
	unblur()

func select_trait(triat_: Bozo.Triat) -> void:
	selected_triats.append(triat_)
	var trait_node = get(Catalog.trait_to_string[triat_])
	trait_node.is_selected = true

func reset_blur() -> void:
	for _trait in selected_triats:
		var trait_node = get(Catalog.trait_to_string[_trait])
		trait_node.is_selected = false
	
	selected_triats.clear()

func unblur() -> void:
	for _trait in traits:
		_trait.is_selected = true

func get_trait_data(trait_: Bozo.Triat) -> TraitData:
	var trait_str = Catalog.trait_to_string[trait_]
	var trait_data: Trait = get(trait_str)
	return trait_data.data
