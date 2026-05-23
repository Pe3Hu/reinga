class_name NightmareData
extends Resource


var trials: Array[TrialData]
var type_to_trial: Dictionary


func _init() -> void:
	init_trials()

func init_trials() -> void:
	for trial in Catalog.trials:
		add_trial(trial)
	
	check_sin_spread()

func add_trial(trial_: Bozo.Trial) -> void:
	var trial = TrialData.new(self, trial_)
	trials.append(trial)
	type_to_trial[trial_] = trial

func check_sin_spread() -> void:
	var sin_to_amount: Dictionary
	var sin_to_weight: Dictionary
	
	for trial in trials:
		for _sin in trial.sins:
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
			
			if trial_data.type_to_sin.has(problem_sin):
				trial_optins.erase(trial_type)
				continue
			
			var is_donor = false
			
			for donor_sin in donor_sins_:
				if trial_data.type_to_sin.has(donor_sin):
					is_donor = true
					break
				
			if !is_donor:
				trial_optins.erase(trial_type)
				continue
		
		if !trial_optins.is_empty():
			var trial_type = trial_optins.pick_random()
			var trial_data = type_to_trial[trial_type]
			var donor_options = []
			
			for donor_sin in trial_data.type_to_sin:
				if donor_sins_.has(donor_sin):
					donor_options.append(donor_sin)
			
			var donor_type = donor_options.pick_random()
			trial_data.swap_sin_type(donor_type, problem_sin)
			sin_to_amount_[donor_type] -= 1
			sin_to_weight_[donor_type] -= trial_data.type_to_sin[problem_sin].value
			
			if !sin_to_amount_.has(problem_sin):
				sin_to_amount_[problem_sin] = 0
				sin_to_weight_[problem_sin] = 0
			
			sin_to_amount_[problem_sin] += 1
			sin_to_weight_[problem_sin] += trial_data.type_to_sin[problem_sin].value
			
			if Catalog.TRIAL_MIN_SIN_AMOUNT - sin_to_amount_[donor_type] >= 0:
				donor_sins_.erase(donor_type)
			
			#rint([Catalog.trial_to_string[trial_type], Catalog.sin_to_string[donor_type], Catalog.sin_to_string[problem_sin]])
		else:
			print("fail swap_sin_type")
