@tool
extends Control
class_name Sinner


@export var fate: Bozo.Fate:
	set(value_):
		fate = value_
		if fate == 0: return
		
		if type_label:
			type_label.text = Catalog.fate_to_string[fate].capitalize()
			faction.type = Catalog.fate_to_faction[fate]

@export var type_label: RichTextLabel
@export var faction: TokenFaction

var traits: Array[Trait]

@export var fear: Trait
@export var horror: Trait
@export var guilt: Trait
@export var repose: Trait

var selected_triats: Array[Bozo.Triat]

var data: SinnerData:
	set(value_):
		data = value_
		
		if data != null:
			%Header.visible = true
			fate = data.fate
			connect_datas()
		else:
			%Header.visible = false


func _ready() -> void:
	traits = [
		fear,
		horror,
		guilt,
		repose
	]
	#var _fate = Catalog.fates.pick_random()
	#data = SinnerData.new(_fate)
	pass

func connect_datas() -> void:
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

func get_selected_trait_datas() -> Array[TraitData]:
	var trait_datas: Array[TraitData]
	
	for _trait in traits:
		if _trait.is_selected == true:
			trait_datas.append(_trait.data)
		
	return trait_datas
