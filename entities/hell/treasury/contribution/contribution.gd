@tool
class_name Contribution
extends PanelContainer


var data: ContributionData:
	set(value_):
		data = value_
		apply_data_info()

@export var treasury: Treasury
@export var candle: Candle
@export var border: ColorRect
@export var margin_panel: MarginContainer

@export var pride: TokenSin
@export var envy: TokenSin
@export var anger: TokenSin
@export var lust: TokenSin
@export var greed: TokenSin
@export var gluttony: TokenSin
@export var madness: TokenPosture
@export var oblivion: TokenPosture
@export var tribute: TokenJudgment

var tokens: Array[Token]
var cage: Cage:
	set(value_):
		cage = value_
		cage.contribution = self
		data.flow.nightmare = cage.jail.hell.nightmare.data


func apply_data_info() -> void:
	pride.data = data.pride
	envy.data = data.envy
	anger.data = data.anger
	lust.data = data.lust
	greed.data = data.greed
	gluttony.data = data.gluttony
	madness.data = data.madness
	oblivion.data = data.oblivion
	tribute.data = data.tribute
	candle.data = data

func get_token(type_: Variant) -> Token:
	var str_type: String
	
	if Catalog.sin_to_string.has(type_):
		str_type = Catalog.sin_to_string[type_]
	if Catalog.posture_to_string.has(type_):
		str_type = Catalog.posture_to_string[type_]
	if Catalog.judgment_to_string.has(type_):
		str_type = Catalog.judgment_to_string[type_]
	
	var token = get(str_type)
	return token
