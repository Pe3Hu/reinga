class_name Nightmare
extends PanelContainer


var data: NightmareData:
	set(value_):
		data = value_
		connect_datas()

@export var hell: Hell
@export var trials: Array[Trial]
var type_to_trial: Dictionary


var drain_tributes: Array[Tribute]
var repletion_attitudes: Array[Attitude]
var development_closed: bool

var payment_dreams: Array[Dream] 
var payment_active: bool
var payment_pending: int

var guild_dreams: Array[Dream]
var guild_pending: int



func connect_datas() -> void:
	for _i in data.trials.size():
		var trial = trials[_i]
		var trial_data = data.trials[_i]
		trial.data = trial_data
		type_to_trial[trial.data.type] = trial

func awaken_dreams() -> void:
	if !Cycle.can_run_phase(Bozo.Phase.PAYMENT):
		return
	
	if payment_active:
		abort_payment()
	
	payment_active = true
	payment_pending = 0
	guild_dreams.clear()
	payment_dreams.clear()
	hell.jail.data.plaza.reset_associations()
	
	for sinner_i in hell.world.data.tribunal.actual.sinners.size():
		var cage = hell.jail.cages[sinner_i]
		var dream = cage.cloak.dream
		cage.apply_moon_layout(false)
		dream.ensure_desires()
		dream.reset_all_desire_tokens()
		dream.show_desires()
		var count = dream.count_payment_dissolve()
		
		if count > 0:
			payment_dreams.append(dream)
		
		payment_pending += count
	
	if payment_pending <= 0:
		end_payment_phase()
		return
	
	_run_payment_dissolves()

func _run_payment_dissolves() -> void:
	if !payment_active or !Cycle.can_run_phase(Bozo.Phase.PAYMENT):
		abort_payment()
		return
	
	for dream in payment_dreams:
		dream.start_payment_dissolve()
	
	payment_dreams.clear()
	
	var desires: Dictionary
	
	for sinner in hell.world.data.tribunal.actual.sinners:
		sinner.dream.update_desires(desires)
	
	for trial in trials:
		var desire = Catalog.trial_to_desire[trial.data.type]
		
		if desires.has(desire):
			var heat_value = desires[desire]
			hell.volcano.burst_splash(trial.flame.progression, heat_value)

func on_payment_desire_finished() -> void:
	if !payment_active: return
	payment_pending -= 1
	
	if payment_pending <= 0:
		end_payment_phase()

func end_payment_phase() -> void:
	if !Cycle.can_run_phase(Bozo.Phase.PAYMENT) or !payment_active:
		return
	
	payment_active = false
	payment_pending = 0
	guild_dreams.clear()
	hell.jail.data.plaza.update_associations()
	Cycle.complete_phase()

func begin_guild_dissolves(pending_: int) -> void:
	guild_pending = pending_
	
	if guild_pending <= 0:
		hell.jail.apply_sun_layout_all()

func on_guild_dissolve_finished() -> void:
	if guild_pending <= 0:
		return
	
	guild_pending -= 1
	
	if guild_pending <= 0:
		hell.jail.apply_sun_layout_all()

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
	payment_dreams.clear()

func abort_guild() -> void:
	guild_pending = 0
	guild_dreams.clear()

func reset() -> void:
	development_closed = false
	
	abort_payment()
	abort_guild()
	
	data.reset()
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

func apply_attitude_privileges() -> void:
	var duration: float = 0
	if !data.privilege_attitudes.is_empty():
		duration =  Gear.splashs[Gear.tempo]
		
		for trial in trials:
			if data.privilege_attitudes.has(trial.attitude.data):
				trial.attitude.apply_privilege()
	
		await get_tree().create_timer(duration).timeout
	Cycle._finish_current()
