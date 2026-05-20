@tool
extends Control
class_name Sinner


@export var fate: Bozo.Fate:
	set(value_):
		fate = value_
		
		if type_label:
			type_label.text = Catalog.fate_to_string[fate].capitalize()
			faction.type = Catalog.fate_to_faction[fate]


@export var type_label: RichTextLabel
@export var faction: TokenFaction

@export var fear: Trait
@export var horror: Trait
@export var guilt: Trait
@export var repose: Trait


var data: SinnerData:
	set(value_):
		data = value_
		fate = data.fate

func _ready() -> void:
	var _fate = Catalog.fates.pick_random()
	data = SinnerData.new(_fate)
	connect_datas()

func connect_datas() -> void:
	fear.data = data.fear
	horror.data = data.horror
	guilt.data = data.guilt
	repose.data = data.repose
