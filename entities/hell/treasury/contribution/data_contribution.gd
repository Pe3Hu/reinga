class_name ContributionData
extends Resource


signal windrose_changed

var treasury: TreasuryData
var cage: CageData

var type: Bozo.Windrose:
	set(value_):
		type = value_
		emit_signal("windrose_changed")

var traits: Array[TraitData]
var tokens: Array[TokenData]
var sins: Array[SinData]
var postures: Array[PostureData]

var candle: CandleData
var pride: SinData
var envy: SinData
var anger: SinData
var lust: SinData
var greed: SinData
var gluttony: SinData
var madness: PostureData
var oblivion: PostureData
var tribute: JudgmentData

#var rank_sum: int = 0
var flow: FlowData
var best_sins: Array[SinData]


func _init(treasury_: TreasuryData, type_: Bozo.Windrose, cage_: CageData) -> void:
	treasury = treasury_
	type = type_
	cage = cage_
	
	cage.contribution = self
	flow = FlowData.new()
	flow.contribution = self
	
	candle = CandleData.new(self)
	pride = SinData.new(Bozo.Sin.PRIDE)
	envy = SinData.new(Bozo.Sin.ENVY)
	anger = SinData.new(Bozo.Sin.ANGER)
	lust = SinData.new(Bozo.Sin.LUST)
	greed = SinData.new(Bozo.Sin.GREED)
	gluttony = SinData.new(Bozo.Sin.GLUTTONY)
	madness = PostureData.new(Bozo.Posture.MADNESS)
	oblivion = PostureData.new(Bozo.Posture.OBLIVION)
	tribute = JudgmentData.new(Bozo.Judgment.TRIBUTE)
	
	tokens = [
		pride,
		envy,
		anger,
		lust,
		greed,
		gluttony,
		madness,
		oblivion,
		tribute,
	]
	sins = [
		pride,
		envy,
		anger,
		lust,
		greed,
		gluttony,
	]
	
	postures = [
		madness,
		oblivion,
	]

func reset() -> void:
	for token in tokens:
		token.reset()
	
	#rank_sum = 0
	traits.clear()

func calc_token_sums() -> void:
	best_sins.clear()
	
	for _trait in traits:
		#rank_sum += _trait.rank
		for _sin in _trait.sins:
			change_token(_sin.type, _sin.value)
		for posture in _trait.postures:
			change_token(posture.type, posture.value)
	
	for omen in treasury.omens:
		change_token(omen.token.type, omen.token.value)
	
	for token in sins:
		updaet_best_sins(token)
	
	flow.calc_tribute_sum()

func change_token(type_: Variant, value_: int) -> void:
	var token = get_token(type_)
	token.value += value_
	
	#updaet_best_sins(token)

func updaet_best_sins(token_) -> void:
	if token_ as SinData:
		#var best_sin
		#
		#for _i in range(best_sins.size()-1,-1-1):
			#best_sin = best_sins.back()
			#
			#if best_sin == null:
				#best_sins.erase(best_sin)
		
		if token_ != null:
			if best_sins.is_empty():
				best_sins.append(token_)
			else:
				if !best_sins.has(token_):
					if best_sins.back().value < token_.value:
						best_sins = [token_]
					if best_sins.back().value == token_.value:
						best_sins.append(token_)

func get_token(type_: Variant) -> TokenData:
	var str_type: String
	
	if Catalog.sin_to_string.has(type_):
		str_type = Catalog.sin_to_string[type_]
	if Catalog.posture_to_string.has(type_):
		str_type = Catalog.posture_to_string[type_]
	if Catalog.judgment_to_string.has(type_):
		str_type = Catalog.judgment_to_string[type_]
	
	var token = get(str_type)
	return token

func update_tokens() -> void:
	reset()
	
	for _trait in Catalog.traits:
		var indexs = Catalog.windrose_to_trait_to_indexs[_trait][type]
		
		for index in indexs:
			var _cage = treasury.hell.jail.table.cages[index]
			var trait_data = _cage.sinner.soul.type_to_trait[_trait]
			traits.append(trait_data)
	
	calc_token_sums()
	
