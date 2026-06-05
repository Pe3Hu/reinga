class_name Nightmare
extends PanelContainer


var data: NightmareData:
	set(value_):
		data = value_
		connect_datas()

@export var hell: Hell
@export var trials: Array[Trial]
var type_to_trial: Dictionary

var dissolve_dreams: Array[Dream]
var drain_tributes: Array[Tribute]
var repletion_attitudes: Array[Attitude]

func reset() -> void:
	dissolve_dreams.clear()
	drain_tributes.clear()
	repletion_attitudes.clear()
	data.refill_claims()

func connect_datas() -> void:
	for _i in data.trials.size():
		var trial = trials[_i]
		var trial_data = data.trials[_i]
		trial.data = trial_data
		type_to_trial[trial.data.type] = trial

func awaken_dreams() -> void:
	for cage in hell.jail.cages:
		cage.cloak.dream.start_dissolve_payment_tokens()
	
	var desires: Dictionary
	
	for sinner in hell.world.data.tribunal.actual.sinners:
		sinner.dream.update_desires(desires)
	
	for trial in trials:
		var desire = Catalog.trial_to_desire[trial.data.type]
		
		if desires.has(desire):
			var heat_value = desires[desire]
			hell.volcano.burst_splash(trial.flame.progression, heat_value)
	

func end_dream_dissolve(dream_: Dream) -> void:
	dissolve_dreams.erase(dream_)
	dream_.cloak.cage.sinner.apply_phase_visiblity()
	
	if dissolve_dreams.is_empty():
		hell.jail.data.plaza.update_associations()
		Scope.next_phase()

func start_drain_tributes() -> void:
	data.find_best_and_worst_tribute()
	
	for trial in trials:
		trial.attitude.start_repletion()
		trial.tribute.start_drain()

func find_best_and_worst_tribute() -> void:
	var worst_value = INF
	var worst_options = []
	var best_value = -INF
	var best_options = []
	
	for trial in trials:
		var value = trial.tribute.progression.data.current_value
		
		if worst_value == value:
			worst_options.append(trial)
		if best_value == value:
			best_options.append(trial)
		if worst_value > value:
			worst_value = value
			worst_options = [trial]
		if best_value < value:
			best_value = value
			best_options = [trial]
	
	var best_trial = best_options.pick_random()
	best_trial.attitude.shifts.append(Catalog.BEST_TRIBUTE_SHIFT) 
	var worst_trial = worst_options.pick_random()
	worst_trial.attitude.shifts.append(Catalog.WORST_TRIBUTE_SHIFT) 

func end_tribute_drain(tribute_: Tribute) -> void:
	drain_tributes.erase(tribute_)
	
	if drain_tributes.is_empty() and repletion_attitudes.is_empty():
		Scope.next_phase()

func end_attitude_repletion(attitude_: Attitude) -> void:
	repletion_attitudes.erase(attitude_)
	
	if drain_tributes.is_empty() and repletion_attitudes.is_empty():
		Scope.next_phase()
