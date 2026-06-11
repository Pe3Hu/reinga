class_name ClaimData
extends Resource


var trial: TrialData

var tooltip: Bozo.Tooltip = Bozo.Tooltip.CLAIM
var sins: Array[SinData]
var type_to_sin: Dictionary
var sit_to_weight: Dictionary


func _init(trial_: TrialData) -> void:
	trial = trial_
	init_sins()

func init_sins() -> void:
	var requirements: Array[int]
	requirements.append_array(Catalog.trial_sin_requirements)
	var amounts = Catalog.trial_sin_amounts
	
	var sin_weights: Dictionary
	var sin_amounts: Dictionary
	
	for _sin in Catalog.trial_to_sin[trial.type]:
		sin_weights[_sin] = Catalog.trial_to_sin[trial.type][_sin]
	
	while !requirements.is_empty():
		var _sin = Helper.get_random_key(sin_weights)
		var amount = amounts.pick_random()
		
		if !sin_amounts.has(_sin):
			sin_amounts[_sin] = 0
		
		sin_amounts[_sin] += amount
		
		if requirements.back() <= sin_amounts[_sin]:
			var requirement = requirements.pop_back()
			add_sin(_sin, requirement)
			sin_amounts.erase(_sin)
			sin_weights.erase(_sin)
			examination(sin_amounts, requirements, sin_weights)
	
	sins.sort_custom(func (a, b): return a.value > b.value)

func add_sin(sin_: Bozo.Sin, value_: int) -> void:
	var sin_data = SinData.new(sin_, value_)
	sins.append(sin_data)
	type_to_sin[sin_] = sin_data
	sit_to_weight[sin_] = value_

func examination(amounts_: Dictionary, requirements_: Array, sin_weights_: Dictionary) -> void:
	if requirements_.is_empty(): return
	var best_amount: int = 0
	
	for _sin in amounts_:
		if best_amount < amounts_[_sin]:
			best_amount = amounts_[_sin]
	
	if requirements_.back() <= best_amount:
		var sin_options: Array[Bozo.Sin]
		
		for _sin in amounts_:
			if best_amount == amounts_[_sin]:
				sin_options.append(_sin)
		
		var _sin = sin_options.pick_random()
		var requirement = requirements_.pop_back()
		add_sin(_sin, requirement)
		amounts_.erase(_sin)
		sin_weights_.erase(_sin)
		examination(amounts_, requirements_, sin_weights_)

func swap_sin_type(old_type_: Bozo.Sin, new_type_: Bozo.Sin) -> void:
	var sin_data = type_to_sin[old_type_]
	sin_data.type = new_type_
	
	type_to_sin.erase(old_type_)
	sit_to_weight.erase(old_type_)
	type_to_sin[new_type_] = sin_data
	sit_to_weight[new_type_] = sin_data.value
	trial.flame.swap_sin_type(old_type_, new_type_)

func refill() -> void:
	for flame_sin in trial.flame.sins:
		var claim_sin = type_to_sin[flame_sin.type]
		claim_sin.value += flame_sin.value
	
	trial.tribute.calc_half()
