class_name FlowData
extends Resource


var contribution: ContributionData
var nightmare: NightmareData
var plaza: PlazaData
var eruptions: Array[EruptionData]

var sin_to_available: Dictionary
var sin_to_demand: Dictionary
var sin_to_trial_to_weight: Dictionary
var sin_to_supply: Dictionary
var modifier_weights: Dictionary
var plaza_available: Dictionary
var sin_to_minus: Dictionary


func init_contribution_eruptions() -> void:
	eruptions.clear()
	sin_to_available.clear()
	sin_to_supply.clear()
	modifier_weights = Helper.get_xalvorr_percents()
	
	for _sin in contribution.sins:
		sin_to_available[_sin.type] = _sin.value
		sin_to_supply[_sin.type] = 0
		sin_to_trial_to_weight[_sin.type] = {}
	
	recalc_sin_to_trial_to_weight()
	spread_available()
	init_minus_contribution_eruptions()

func spread_available() -> void:
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
	
	if contribution:
		for _sin in contribution.sins:
			sin_to_available[_sin.type] = _sin.value - sin_to_supply[_sin.type]
	
	if plaza:
		for sin_type in plaza_available:
			plaza_available[sin_type] -= sin_to_supply[sin_type]
	
	for deal in nightmare.hell.market.deals:
		if sin_to_available.has(deal.sin_data.type):
			var amount = min(deal.sin_data.value, sin_to_available[deal.sin_data.type])
			var sin_type = deal.sin_data.type
			
			for _i in amount:
				var eruption = EruptionData.new(self, sin_type, eruption_type)
				eruptions.append(eruption)
			
			sin_to_available[sin_type] -= amount
	
	distribute_postures()

func distribute_postures() -> void:
	if plaza:
		print("temp distribute_postures ignore for plaza")
		return
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

func init_plaza_eruptions() -> void:
	eruptions.clear()
	sin_to_available.clear()
	sin_to_trial_to_weight.clear()
	modifier_weights = Helper.get_xalvorr_percents()
	sin_to_supply.clear()
	plaza_available.clear()
	
	for faction_type in plaza.type_to_faction:
		for faction in plaza.type_to_faction[faction_type]:
			var sins = faction.get_token_for_eruptions()
			
			for _sin in sins:
				if !sin_to_available.has(_sin.type):
					sin_to_available[_sin.type] = 0
					sin_to_supply[_sin.type] = 0
					sin_to_trial_to_weight[_sin.type] = {}
				
				sin_to_available[_sin.type] += _sin.value
	
	plaza_available = sin_to_available.duplicate()
	extract_plaza_minus_sins()
	recalc_sin_to_trial_to_weight()
	spread_available()
	init_minus_plaza_eruptions()

func extract_plaza_minus_sins() -> void:
	sin_to_minus.clear()
	
	for sin_type in sin_to_available.keys():
		if sin_to_available[sin_type] <= 0:
			if sin_to_available[sin_type] < 0:
				sin_to_minus[sin_type] = abs(sin_to_available[sin_type])
			
			sin_to_available.erase(sin_type)
			plaza_available.erase(sin_type)

func recalc_sin_to_trial_to_weight() -> void:
	for trial in nightmare.trials:
		for _sin in trial.claim.sins:
			if sin_to_trial_to_weight.has(_sin.type):
				sin_to_trial_to_weight[_sin.type][trial.type] = _sin.value

func init_minus_contribution_eruptions() -> void:
	sin_to_minus.clear()
	
	for _sin in contribution.sins:
		if _sin.value < 0:
			sin_to_minus[_sin.type] = abs(_sin.value)
	
	recalc_sin_to_trial_to_weight()
	spread_minus()

func spread_minus() -> void:
	while sin_to_minus:
		var sin_type = Helper.get_random_key(sin_to_minus)
		
		if sin_type == null:
			sin_to_minus.clear()
			break
		
		var trial = Helper.get_random_key(sin_to_trial_to_weight[sin_type])
		
		if trial != null:
			var modifier = Helper.get_random_key(modifier_weights)
			var amount = 1
			#var factor = Catalog.modifier_to_factor[modifier]
			
			#if modifier == Bozo.Modifier.NONE:
				#amount = randi_range(1, sin_to_trial_to_weight[sin_type][trial])
			#
			#if modifier != Bozo.Modifier.MISS:
				#amount = min(sin_to_minus[sin_type], amount * factor)
			
			sin_to_minus[sin_type] -= amount
			
			for _i in amount:
				var eruption_type = Catalog.trial_to_eruption[trial]
				var eruption = EruptionData.new(self, sin_type, eruption_type, modifier)
				eruption.status = Bozo.Status.OFF
				eruptions.append(eruption)
			
			if sin_to_minus[sin_type] == 0:
				sin_to_minus.erase(sin_type)
			
			sin_to_trial_to_weight[sin_type][trial] += amount
		else:
			sin_to_minus.erase(sin_type)
	
	eruptions.shuffle()

func init_minus_plaza_eruptions() -> void:
	if sin_to_minus.is_empty():
		return
	
	recalc_sin_to_trial_to_weight()
	spread_minus()
