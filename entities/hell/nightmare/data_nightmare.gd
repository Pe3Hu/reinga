class_name NightmareData
extends Resource


var hell: HellData
var trials: Array[TrialData]
var type_to_trial: Dictionary

var best_tribute: TributeData
var worst_tribute: TributeData
var best_attitude: AttitudeData
var worst_attitude: AttitudeData
var best_flame: FlameData
var worst_flame: FlameData

var development_closed: bool = false


#region init
func _init(hell_: HellData) -> void:
	hell = hell_
	init_trials()

func init_trials() -> void:
	for trial in Catalog.trials:
		add_trial(trial)
	
	check_sin_spread()

func add_trial(trial_: Bozo.Trial) -> void:
	var trial = TrialData.new(self, trial_)
	trials.append(trial)
	type_to_trial[trial_] = trial
#endregion

func check_sin_spread() -> void:
	var sin_to_amount: Dictionary
	var sin_to_weight: Dictionary
	
	for trial in trials:
		for _sin in trial.claim.sins:
			if !sin_to_amount.has(_sin.type):
				sin_to_amount[_sin.type] = 0
				sin_to_weight[_sin.type] = 0
			
			sin_to_amount[_sin.type] += 1
			sin_to_weight[_sin.type] += _sin.value
	
	var keys = sin_to_amount.keys()
	
	var problem_sins: Array[Bozo.Sin]
	var donor_sins: Array[Bozo.Sin]
	
	if keys.size() != Catalog.sins.size():
		donor_sins.append_array(keys)
		problem_sins.append_array(Catalog.sins)
		problem_sins = problem_sins.filter(
			func (a): return !donor_sins.has(a)
		)
		
		problem_sins.append(problem_sins.back())
		
		implement_missing_sin(sin_to_amount, sin_to_weight, problem_sins, donor_sins)
		return
	else:
		for key in keys:
			var defect_amount = Catalog.TRIAL_MIN_SIN_AMOUNT - sin_to_amount[key]
			for _i in defect_amount:
				problem_sins.append(key)
			
			if defect_amount < 0:
				donor_sins.append(key)
		
		if !problem_sins.is_empty():
			implement_missing_sin(sin_to_amount, sin_to_weight, problem_sins, donor_sins)
			
	
	#keys.sort_custom(func(a, b):
		#return sin_to_weight[a] > sin_to_weight[b]
	#)
	#
	#for key in keys:
		#print([Catalog.sin_to_string[key], sin_to_amount[key], sin_to_weight[key]])

func implement_missing_sin(sin_to_amount_: Dictionary, sin_to_weight_: Dictionary, problem_sins_: Array[Bozo.Sin], donor_sins_: Array[Bozo.Sin]) -> void:
	while !problem_sins_.is_empty():
		var problem_sin = problem_sins_.pop_back()
		donor_sins_.sort_custom(func(a, b):
			return sin_to_amount_[a] < sin_to_amount_[b]
		)
		var trial_optins: Array[Bozo.Trial]
		trial_optins.append_array(Catalog.sin_to_trial[problem_sin])
		
		for _i in range(trial_optins.size()-1, -1, -1):
			var trial_type = trial_optins[_i]
			var trial_data = type_to_trial[trial_type]
			
			if trial_data.claim.type_to_sin.has(problem_sin):
				trial_optins.erase(trial_type)
				continue
			
			var is_donor = false
			
			for donor_sin in donor_sins_:
				if trial_data.claim.type_to_sin.has(donor_sin):
					is_donor = true
					break
				
			if !is_donor:
				trial_optins.erase(trial_type)
				continue
		
		if !trial_optins.is_empty():
			var trial_type = trial_optins.pick_random()
			var trial_data = type_to_trial[trial_type]
			var donor_options = []
			
			for donor_sin in trial_data.claim.type_to_sin:
				if donor_sins_.has(donor_sin):
					donor_options.append(donor_sin)
			
			var donor_type = donor_options.pick_random()
			trial_data.claim.swap_sin_type(donor_type, problem_sin)
			sin_to_amount_[donor_type] -= 1
			sin_to_weight_[donor_type] -= trial_data.claim.type_to_sin[problem_sin].value
			
			if !sin_to_amount_.has(problem_sin):
				sin_to_amount_[problem_sin] = 0
				sin_to_weight_[problem_sin] = 0
			
			sin_to_amount_[problem_sin] += 1
			sin_to_weight_[problem_sin] += trial_data.claim.type_to_sin[problem_sin].value
			
			if Catalog.TRIAL_MIN_SIN_AMOUNT - sin_to_amount_[donor_type] >= 0:
				donor_sins_.erase(donor_type)
			
			#rint([Catalog.trial_to_string[trial_type], Catalog.sin_to_string[donor_type], Catalog.sin_to_string[problem_sin]])
		else:
			print("fail swap_sin_type")

#region best and worst
func update_best_and_worst_tribute() -> void:
	var worst_value = INF
	var worst_options = []
	var best_value = -INF
	var best_options = []
	
	for trial in trials:
		var value = trial.tribute.progression.current_value
		
		if worst_value == value:
			worst_options.append(trial.tribute)
		if best_value == value:
			best_options.append(trial.tribute)
		if worst_value > value:
			worst_value = value
			worst_options = [trial.tribute]
		if best_value < value:
			best_value = value
			best_options = [trial.tribute]
	
	best_tribute = best_options.pick_random()
	worst_tribute = worst_options.pick_random()

func update_best_and_worst_flame() -> void:
	var worst_value = -INF
	var worst_options = []
	var best_value = INF
	var best_options = []
	
	for trial in trials:
		var value = trial.flame.progression.current_value
		value += Catalog.flame_to_baggage[trial.flame.level]
		
		if worst_value == value:
			worst_options.append(trial.flame)
		if best_value == value:
			best_options.append(trial.flame)
		if worst_value < value:
			worst_value = value
			worst_options = [trial.flame]
		if best_value > value:
			best_value = value
			best_options = [trial.flame]
	
	best_flame = best_options.pick_random()
	worst_flame = worst_options.pick_random()

func update_best_and_worst_attitude() -> void:
	var worst_value = INF
	var worst_options = []
	var best_value = -INF
	var best_options = []
	
	for trial in trials:
		var minus_bowl = trial.attitude.blob_to_bowls[Bozo.Blob.MINUS]
		var plus_bowl = trial.attitude.blob_to_bowls[Bozo.Blob.PLUS]
		var minus_value = minus_bowl.get_value_with_baggage()
		var plus_value = plus_bowl.get_value_with_baggage()
		
		if worst_value == minus_value:
			worst_options.append(trial.attitude)
		if best_value == plus_value:
			best_options.append(trial.attitude)
		if worst_value > minus_value:
			worst_value = minus_value
			worst_options = [trial.attitude]
		if best_value < plus_value:
			best_value = plus_value
			best_options = [trial.attitude]
	
	best_attitude = best_options.pick_random()
	worst_attitude = worst_options.pick_random()
#endregion

func reset() -> void:
	development_closed = false
	best_tribute = null
	worst_tribute = null
	best_attitude = null
	worst_attitude = null
	best_flame = null
	worst_flame = null

func refill_claims() -> void:
	for trail in trials:
		trail.claim.refill()
