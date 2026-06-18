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
var development_closed: bool
var payment_active: bool
var payment_pending: int


func connect_datas() -> void:
	for _i in data.trials.size():
		var trial = trials[_i]
		var trial_data = data.trials[_i]
		trial.data = trial_data
		type_to_trial[trial.data.type] = trial

func awaken_dreams() -> void:
	if !Cycle.can_run_phase(Bozo.Phase.PAYMENT) or payment_active:
		return
	
	payment_active = true
	payment_pending = 0
	dissolve_dreams.clear()
	hell.jail.data.plaza.reset_associations()
	
	for sinner_i in hell.world.data.tribunal.actual.sinners.size():
		var dream = hell.jail.cages[sinner_i].cloak.dream
		dream.sync_desire_bindings()
		dream.show_desires()
		payment_pending += dream.begin_payment_dissolve()
	
	if payment_pending <= 0:
		end_payment_phase()
		return
	
	var desires: Dictionary
	
	for sinner in hell.world.data.tribunal.actual.sinners:
		sinner.dream.update_desires(desires)
	
	for trial in trials:
		var desire = Catalog.trial_to_desire[trial.data.type]
		
		if desires.has(desire):
			var heat_value = desires[desire]
			hell.volcano.burst_splash(trial.flame.progression, heat_value)

func on_payment_desire_finished() -> void:
	if !payment_active:
		return
	
	payment_pending -= 1
	
	if payment_pending <= 0:
		end_payment_phase()

func end_payment_phase() -> void:
	if !Cycle.can_run_phase(Bozo.Phase.PAYMENT) or !payment_active:
		return
	
	payment_active = false
	payment_pending = 0
	dissolve_dreams.clear()
	hell.weather_button.switch_weather()
	hell.jail.data.plaza.update_associations()
	Cycle.complete_phase()

func start_drain_tributes() -> void:
	data.update_best_and_worst_tribute()
	var best_trial = data.best_tribute.trial
	best_trial.attitude.shifts.append(Catalog.BEST_TRIBUTE_SHIFT) 
	var worst_trial = data.worst_tribute.trial
	worst_trial.attitude.shifts.append(Catalog.WORST_TRIBUTE_SHIFT) 
	
	for trial in trials:
		trial.attitude.start_repletion()
		trial.tribute.start_drain()

func end_tribute_drain(tribute_: Tribute) -> void:
	drain_tributes.erase(tribute_)
	
	if drain_tributes.is_empty() and repletion_attitudes.is_empty():
		end_development_phase()

func end_attitude_repletion(attitude_: Attitude) -> void:
	repletion_attitudes.erase(attitude_)
	
	if drain_tributes.is_empty() and repletion_attitudes.is_empty():
		end_development_phase()

func end_development_phase() -> void:
	if development_closed or !Cycle.can_run_phase(Bozo.Phase.DEVELOPMENT):
		return
	
	development_closed = true
	
	if hell.world.herald.data.decrees.is_empty():
		Cycle.complete_phase()
	else:
		#Cycle.complete_phase()
		Cycle.suspend(Bozo.Interrupt.HERALD_DECREE)
		hell.world.transition.data.next_layer = Bozo.Layer.HERALD

func abort_payment() -> void:
	payment_active = false
	payment_pending = 0
	dissolve_dreams.clear()

func reset() -> void:
	development_closed = false
	payment_active = false
	payment_pending = 0
	data.reset()
	dissolve_dreams.clear()
	drain_tributes.clear()
	repletion_attitudes.clear()
	data.refill_claims()

func get_progression(data_: ProgressionData) -> Progression:
	var progression: Progression
	var boss_string = Catalog.tooltip_to_string[data_.boss.tooltip]
	#var trial_type = Catalog.trial_to_string[data_.boss.trial.type]  
	var trial = type_to_trial[data_.boss.trial.type]
	var boss = trial.get(boss_string)
	return boss.progression

func apply_attitude_shifts() -> void:
	for trial in trials:
		trial.attitude.apply_shifts()
