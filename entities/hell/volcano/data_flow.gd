class_name FlowData
extends Resource


var contribution: ContributionData
var nightmare: NightmareData
var eruptions: Array[EruptionData]

var sin_to_available: Dictionary
var sin_to_demand: Dictionary
var sin_to_trial_to_weight: Dictionary
var sin_to_supply: Dictionary


func init_eruptions() -> void:
	eruptions.clear()
	sin_to_available.clear()
	sin_to_supply.clear()
	sin_to_trial_to_weight.clear()
	var modifier_weights = nightmare.hell.shelter.get_modifier_weights()
	
	for _sin in contribution.sins:
		sin_to_available[_sin.type] = _sin.value
		sin_to_supply[_sin.type] = 0
		sin_to_trial_to_weight[_sin.type] = {}
	
	for trial in nightmare.trials:
		for _sin in trial.claim.sins:
			if sin_to_trial_to_weight.has(_sin.type):
				sin_to_trial_to_weight[_sin.type][trial.type] = _sin.value
	
	while sin_to_available:
		var sin_type = Helper.get_random_key(sin_to_available)
		
		if sin_type == null:
			sin_to_available.clear()
			break
		
		if !sin_to_trial_to_weight.has(sin_type):
			sin_to_available.erase(sin_type)
			continue
		
		var trial = Helper.get_random_key(sin_to_trial_to_weight[sin_type])
		
		if trial != null:
			var modifier = Helper.get_random_key(modifier_weights)
			var amount = 1
			var factor = Catalog.modifier_to_factor[modifier]
			
			if modifier == Bozo.Modifier.NONE:
				amount = randi_range(1, sin_to_trial_to_weight[sin_type][trial])
			
			if modifier != Bozo.Modifier.MISS:
				amount = min(sin_to_available[sin_type], amount * factor)
			
			sin_to_available[sin_type] -= amount
			sin_to_supply[sin_type] += amount
			
			for _i in amount:
				var eruption_type = Catalog.trial_to_eruption[trial]
				var eruption = EruptionData.new(self, sin_type, eruption_type, modifier)
				eruptions.append(eruption)
			
			if sin_to_available[sin_type] == 0:
				sin_to_available.erase(sin_type)
			
			sin_to_trial_to_weight[sin_type][trial] -= amount
			
			if sin_to_trial_to_weight[sin_type][trial] == 0:
				sin_to_trial_to_weight[sin_type].erase(trial)
			
			if sin_to_trial_to_weight[sin_type].keys().is_empty():
				sin_to_trial_to_weight.erase(sin_type)
		else:
			sin_to_available.erase(sin_type)
	
	distribute_available()
	eruptions.shuffle()

func distribute_available() -> void:
	sin_to_available.clear()
	var eruption_type = Bozo.Eruption.MARKET
	
	for _sin in contribution.sins:
		sin_to_available[_sin.type] = _sin.value - sin_to_supply[_sin.type]
		
	for deal in nightmare.hell.market.deals:
		var amount = min(deal.sin_data.value, sin_to_available[deal.sin_data.type])
		var type = Catalog.sin_to_token[deal.sin_data.type]
		
		for _i in amount:
			var eruption = EruptionData.new(self, type, eruption_type)
			eruptions.append(eruption)
	
	distribute_postures()

func distribute_postures() -> void:
	var eruption_type = Bozo.Eruption.BANK
	
	for posture in contribution.postures:
		var amount = posture.value
		var type = Catalog.posture_to_token[posture.type]
		
		for _i in amount:
			var eruption = EruptionData.new(self, type, eruption_type)
			eruptions.append(eruption)

func calc_tribute_sum() -> void:
	contribution.tribute.value = 0
	sin_to_available.clear()
	sin_to_demand.clear()
	
	for _sin in contribution.sins:
		sin_to_available[_sin.type] = _sin.value
		sin_to_demand[_sin.type] = 0
	
	for trial in nightmare.trials:
		for _sin in trial.claim.sins:
			if sin_to_demand.has(_sin.type):
				sin_to_demand[_sin.type] += _sin.value
	
	for sin_type in sin_to_available:
		contribution.tribute.value += min(sin_to_demand[sin_type], sin_to_available[sin_type])
