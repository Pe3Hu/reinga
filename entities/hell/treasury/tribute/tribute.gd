@tool
class_name Tribute
extends PanelContainer


var data: TributeData = TributeData.new()

@export var treasury: Treasury
@export var candle: Candle

@export var pride: TokenSin
@export var envy: TokenSin
@export var anger: TokenSin
@export var lust: TokenSin
@export var greed: TokenSin
@export var gluttony: TokenSin
@export var madness: TokenPosture
@export var oblivion: TokenPosture


var tokens: Array[Token]


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
	for token in tokens:
		token.reset()

func get_token(type_: Variant) -> Token:
	var str_type: String
	
	if Catalog.sin_to_string.has(type_):
		str_type = Catalog.sin_to_string[type_]
	if Catalog.posture_to_string.has(type_):
		str_type = Catalog.posture_to_string[type_]
	
	var token = get(str_type)
	return token

func change_token_value(type_: Variant, value_) -> void:
	var token = get_token(type_)
	token.value += value_

func update_tokens() -> void:
	reset_tokens()
	
	var indexs = Catalog.windrose_to_indexs[candle.windrose]
	
	for index in indexs:
		var cage = treasury.hell.jail.cages.get_child(index)
		var trait_datas = cage.sinner.get_selected_trait_datas()
		data.traits.append_array(trait_datas)
	
	data.recalc()
	
	for token_data in data.tokens:
		change_token_value(token_data.type, token_data.value)
