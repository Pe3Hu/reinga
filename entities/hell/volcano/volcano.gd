class_name Volcano
extends Node


@export var eruption_scene: PackedScene

@export var hell: Hell
@export var trials: Array[Trial]
@export var tokens: Array[TokenSin]

@export var total_eruptions: int
@export var spawn_duration: float = 1.5

var pool: Array[Eruption]


func _ready() -> void:
	prewarm(Catalog.DEFAULT_ERUPTION_COUNT)

func prewarm(count_: int):
	for _i in count_:
		var eruption = eruption_scene.instantiate() as Eruption
		eruption.visible = false
		eruption.set_process(false)
		eruption.volcano = self
		pool.append(eruption)

func get_eruption() -> Eruption:
	var eruption: Eruption
	
	if pool.size() > 0:
		eruption = pool.pop_back()
	else:
		eruption = eruption_scene.instantiate() as Eruption
		eruption.volcano = self

	eruption.activate()
	return eruption

func return_eruption(eruption_: Eruption):
	eruption_.visible = false
	eruption_.set_process(false)
	pool.append(eruption_)

func burst():
	fill_trials()
	total_eruptions = min(tokens.size(), trials.size())
	var step := spawn_duration / float(total_eruptions)

	for _i in range(total_eruptions):
		await get_tree().create_timer(step).timeout
		spawn_eruption(_i)

func fill_trials() -> void:
	var tribute = hell.jail.active_cage.tribute
	
	var sin_to_available: Dictionary
	var sin_to_trial_to_weight: Dictionary
	var awaited_sins: Array#[Bozo.Sin]
	
	for token in tribute.tokens:
		if token is TokenSin:
			sin_to_available[token.type] = token.value
			sin_to_trial_to_weight[token.type] = {}
	
	for trial in hell.nightmare.trials:
		for sin_data in trial.sins:
			if sin_to_trial_to_weight.has(sin_data.type):
				sin_to_trial_to_weight[sin_data.type][trial] = sin_data.value
	
	while sin_to_available:
		var sin_type = Helper.get_random_key(sin_to_available)
		
		if sin_type == null:
			sin_to_available.clear()
			break
		
		if !sin_to_trial_to_weight.has(sin_type):
			awaited_sins.append(sin_type)
			sin_to_available.erase(sin_type)
			continue
		
		var trial = Helper.get_random_key(sin_to_trial_to_weight[sin_type])
		var amount = randi_range(1, sin_to_trial_to_weight[sin_type][trial])
		var token = tribute.get_token(sin_type)
		
		for _i in amount:
			tokens.append(token)
			trials.append(trial)
		
		sin_to_available[sin_type] -= amount
		
		if sin_to_available[sin_type] <= 0:
			sin_to_available.erase(sin_type)
		
		sin_to_trial_to_weight[sin_type][trial] -= amount
		
		if sin_to_trial_to_weight[sin_type][trial] <= 0:
			sin_to_trial_to_weight[sin_type].erase(trial)
		
		if sin_to_trial_to_weight[sin_type].keys().is_empty():
			sin_to_trial_to_weight.erase(sin_type)

func spawn_eruption(index_: int):
	if trials.is_empty() or tokens.is_empty():
		push_error("Start or End points are not assigned!")
		return

	var eruption := get_eruption()
	
	if eruption.get_parent() == null:
		add_child(eruption)

	var trial = trials[index_]
	var token = tokens[index_]
	eruption.reset(token, trial)
