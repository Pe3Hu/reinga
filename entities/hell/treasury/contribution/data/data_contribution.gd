class_name ContributionData
extends Resource


var traits: Array[TraitData]
var tokens: Array[TokenData]
var sins: Array[SinData]

var pride: SinData = SinData.new(Bozo.Sin.PRIDE)
var envy: SinData = SinData.new(Bozo.Sin.ENVY)
var anger: SinData = SinData.new(Bozo.Sin.ANGER)
var lust: SinData = SinData.new(Bozo.Sin.LUST)
var greed: SinData = SinData.new(Bozo.Sin.GREED)
var gluttony: SinData = SinData.new(Bozo.Sin.GLUTTONY)
var madness: PostureData = PostureData.new(Bozo.Posture.MADNESS)
var oblivion: PostureData = PostureData.new(Bozo.Posture.OBLIVION)

var rank_sum: int = 0


func _init() -> void:
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
	sins = [
		pride,
		envy,
		anger,
		lust,
		greed,
		gluttony,
	]

func reset() -> void:
	for token in tokens:
		token.reset()
	
	rank_sum = 0
	traits.clear()

func recalc() -> void:
	for _trait in traits:
		rank_sum += _trait.rank
		
		for _sin in _trait.sins:
			change_token(_sin.type, _sin.value)
		for posture in _trait.postures:
			change_token(posture.type, posture.value)

func change_token(type_: Variant, value_: int) -> void:
	var token = get_token(type_)
	token.value += value_

func get_token(type_: Variant) -> TokenData:
	var str_type: String
	
	if Catalog.sin_to_string.has(type_):
		str_type = Catalog.sin_to_string[type_]
	if Catalog.posture_to_string.has(type_):
		str_type = Catalog.posture_to_string[type_]
	
	var token = get(str_type)
	return token
