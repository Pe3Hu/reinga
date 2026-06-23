class_name FlowData
extends Resource


var contribution: ContributionData
var nightmare: NightmareData
var plaza: PlazaData
var bank: Bank
var eruptions: Array[EruptionData]

var sin_to_available: Dictionary
var amber_available: int
var amber_sin_type: Bozo.Sin
var amber_is_indolence: bool
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
	
	init_amber_available()
	recalc_sin_to_trial_to_weight()
	if amber_is_indolence:
		recalc_indolence_claim_weights()
	spread_available()
	init_minus_contribution_eruptions()

func init_amber_available() -> void:
	amber_available = 0
	amber_sin_type = Bozo.Sin.NONE
	amber_is_indolence = false
	
	if bank == null or bank.active_safe == null:
		return
	
	var amber_data = bank.active_safe.amber.data
	if amber_data.value <= 0:
		return
	
	if amber_data.type == Bozo.Amber.INDOLENCE:
		amber_is_indolence = true
		amber_available = amber_data.value
		return
	
	if !Catalog.amber_to_sin.has(amber_data.type):
		return
	
	amber_available = amber_data.value
	amber_sin_type = Catalog.amber_to_sin[amber_data.type]

func recalc_indolence_claim_weights() -> void:
	for trial in nightmare.trials:
		for _sin in trial.claim.sins:
			if _sin.value <= 0:
				continue
			
			if !sin_to_trial_to_weight.has(_sin.type):
				sin_to_trial_to_weight[_sin.type] = {}
			
			sin_to_trial_to_weight[_sin.type][trial.type] = _sin.value

func has_indolence_targets() -> bool:
	for sin_type in sin_to_trial_to_weight:
		for trial in sin_to_trial_to_weight[sin_type]:
			if sin_to_trial_to_weight[sin_type][trial] > 0:
				return true
	return false

func pick_indolence_target() -> Dictionary:
	var options: Array[Dictionary] = []
	
	for sin_type in sin_to_trial_to_weight:
		for trial in sin_to_trial_to_weight[sin_type]:
			if sin_to_trial_to_weight[sin_type][trial] > 0:
				options.append({sin_type = sin_type, trial = trial})
	
	if options.is_empty():
		return {}
	
	return options.pick_random()

func pick_spread_source() -> Dictionary:
	var can_amber = amber_available > 0
	
	if amber_is_indolence:
		can_amber = can_amber and has_indolence_targets()
	else:
		can_amber = (
			can_amber
			and sin_to_trial_to_weight.has(amber_sin_type)
			and !sin_to_trial_to_weight[amber_sin_type].is_empty()
		)
	var can_contribution = !sin_to_available.is_empty()
	
	if !can_amber and !can_contribution:
		return {}
	
	if can_amber and !can_contribution:
		if amber_is_indolence:
			return {from_safe = true}
		return {from_safe = true, sin_type = amber_sin_type}
	
	if can_contribution and !can_amber:
		return {from_safe = false, sin_type = Helper.get_random_key(sin_to_available)}
	
	var weights = {
		amber = float(amber_available),
		contribution = 0.0,
	}
	
	for sin_type in sin_to_available:
		weights.contribution += sin_to_available[sin_type]
	
	if Helper.get_random_key(weights) == "amber":
		if amber_is_indolence:
			return {from_safe = true}
		return {from_safe = true, sin_type = amber_sin_type}
	
	return {from_safe = false, sin_type = Helper.get_random_key(sin_to_available)}

func spread_available() -> void:
	while sin_to_available or amber_available > 0:
		var source = pick_spread_source()
		
		if source.is_empty():
			break
		
		var from_safe: bool = source.from_safe
		var sin_type = source.get("sin_type")
		var trial = null
		
		if from_safe and amber_is_indolence:
			var target = pick_indolence_target()
			if target.is_empty():
				amber_available = 0
				continue
			sin_type = target.sin_type
			trial = target.trial
		elif sin_type == null:
			sin_to_available.clear()
			amber_available = 0
			break
		
		if !from_safe or !amber_is_indolence:
			if sin_type == null:
				sin_to_available.clear()
				amber_available = 0
				break
			
			if !sin_to_trial_to_weight.has(sin_type):
				if from_safe:
					amber_available = 0
				else:
					sin_to_available.erase(sin_type)
				continue
			
			trial = Helper.get_random_key(sin_to_trial_to_weight[sin_type])
		
		if trial != null:
			var modifier = Helper.get_random_key(modifier_weights)
			var amount = 1
			var factor = Catalog.modifier_to_factor[modifier]
			
			if modifier == Bozo.Modifier.NONE:
				amount = randi_range(1, sin_to_trial_to_weight[sin_type][trial])
			
			if from_safe:
				if modifier != Bozo.Modifier.MISS:
					amount = min(amber_available, amount * factor)
				amber_available -= amount
			else:
				if modifier != Bozo.Modifier.MISS:
					amount = min(sin_to_available[sin_type], amount * factor)
				sin_to_available[sin_type] -= amount
				sin_to_supply[sin_type] += amount
			
			for _i in amount:
				var eruption_type = Catalog.trial_to_eruption[trial]
				var eruption = EruptionData.new(self, sin_type, eruption_type, modifier)
				eruption.from_safe = from_safe
				eruptions.append(eruption)
			
			if !from_safe and sin_to_available[sin_type] == 0:
				sin_to_available.erase(sin_type)
			
			sin_to_trial_to_weight[sin_type][trial] -= amount
			
			if sin_to_trial_to_weight[sin_type][trial] == 0:
				sin_to_trial_to_weight[sin_type].erase(trial)
			
			if sin_to_trial_to_weight[sin_type].keys().is_empty():
				sin_to_trial_to_weight.erase(sin_type)
		elif from_safe:
			amber_available = 0
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
