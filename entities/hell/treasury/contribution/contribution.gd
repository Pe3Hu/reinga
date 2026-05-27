@tool
class_name Contribution
extends PanelContainer


var data: ContributionData = ContributionData.new()

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
@export var rank: TokenJudgment

var tokens: Array[Token]
var cage: Cage


func _ready() -> void:
	tokens = [
		pride,
		envy,
		anger,
		lust,
		greed,
		gluttony,
		madness,
		oblivion,
	]
	
	reset_tokens()

func reset_tokens() -> void:
	data.reset()
	
	for token in tokens:
		token.reset()
	
	rank.value = 0

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

func change_token_value(type_: Variant, value_) -> void:
	var token = get_token(type_)
	token.value += value_

func update_tokens() -> void:
	reset_tokens()
	
	for _trait in Catalog.traits:
		var indexs = Catalog.windrose_to_trait_to_indexs[_trait][candle.windrose]
		
		for index in indexs:
			var _cage = treasury.hell.jail.cages[index]
			var trait_data = _cage.sinner.soul.get_trait_data(_trait)
			data.traits.append(trait_data)
	
	data.recalc()
	rank.value = data.rank_sum
	
	for token_data in data.tokens:
		change_token_value(token_data.type, token_data.value)
