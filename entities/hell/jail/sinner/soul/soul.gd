class_name Soul
extends MarginContainer


var data: SoulData:
	set(value_):
		data = value_
		connect_datas()
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
	reset()
	fear.data = data.fear
	horror.data = data.horror
	guilt.data = data.guilt
	repose.data = data.repose
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

func blur() -> void:
	for _trait in traits:
		_trait.is_selected = false

func get_trait_data(trait_: Bozo.Triat) -> TraitData:
	var trait_str = Catalog.trait_to_string[trait_]
	var trait_data: Trait = get(trait_str)
	return trait_data.data

func reset() -> void:
	for _trait in traits:
		_trait.reset()
