class_name TraitData
extends Resource


signal type_changed
@warning_ignore("unused_signal")
signal is_selected_changed

var soul: SoulData
var type: Bozo.Trait:
	set(value_):
		if type != value_:
			type = value_
			emit_signal("type_changed")
var rank: int

var sins: Array[SinData]
var postures: Array[PostureData]
var is_selected: bool = false:
	set(value_):
		if is_selected != value_:
			is_selected = value_
			emit_signal("is_selected_changed")


#region init
func _init(soul_: SoulData, type_: Bozo.Trait, rank_: int) -> void:
	soul = soul_
	type = type_
	rank = rank_
	
	init_tokens()

func init_tokens() -> void:
	var amount_options = Catalog.rank_to_trait_to_amount[rank][type]
	var amounts = amount_options.pick_random()
	
	var token_types: Array
	
	if type == Bozo.Trait.REPOSE:
		var amount = amounts.back()
		add_posture(Bozo.Posture.OBLIVION, amount)
	else:
		token_types.append_array(Catalog.fate_to_sin[soul.sinner.fate.type])
		token_types.shuffle()
	
		for amount in amounts:
			var token_type = token_types.pop_back()
			add_sin(token_type, amount)
	
	if type == Bozo.Trait.HORROR:
		var amount = 1
		add_posture(Bozo.Posture.MADNESS, amount)

func add_sin(type_: Bozo.Sin, value_: int) -> void:
	var _sin = SinData.new(type_, value_)
	sins.append(_sin)

func add_posture(type_: Bozo.Posture, value_: int) -> void:
	var posture = PostureData.new(type_, value_)
	postures.append(posture)
#endregion
