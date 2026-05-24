class_name Volcano
extends Node


@export var eruption_scene: PackedScene
@export var splash_scene: PackedScene


@export var hell: Hell
@export var trials: Array[Trial]
@export var tokens: Array[TokenSin]

@export var total_eruptions: int

var eruption_pool: Array[Eruption]
var splash_pool: Array[Splash]
var trail_pool: Array[Sprite2D]

@export var camera_2d: Camera2D

var camera_shake_noise: FastNoiseLite = FastNoiseLite.new()


func _ready() -> void:
	prewarm_eruption(Catalog.DEFAULT_ERUPTION_COUNT)
	prewarm_splash(Catalog.DEFAULT_SPLASH_COUNT)
	setup_trail_pool(Catalog.DEFAULT_ERUPTION_COUNT * 10)

func prewarm_eruption(count_: int):
	for _i in count_:
		add_eruption()

func add_eruption() -> Eruption:
	var eruption = eruption_scene.instantiate() as Eruption
	eruption.visible = false
	eruption.volcano = self
	eruption_pool.append(eruption)
	return eruption

func setup_trail_pool(count_: int) -> void:
	for i in count_:
		var newSprite: Sprite2D = Sprite2D.new()
		newSprite.texture = load("uid://dugn64otk6dcd")
		newSprite.z_index = 0
		newSprite.modulate.a = 0.0
		%Trails.add_child.call_deferred(newSprite)
		trail_pool.append(newSprite)

func get_eruption() -> Eruption:
	var eruption: Eruption

	if eruption_pool.size() > 0:
		eruption = eruption_pool.pop_back()
	else:
		eruption = eruption_scene.instantiate() as Eruption
		eruption.volcano = self
	
	if eruption.get_parent() == null:
		%Eruptions.add_child(eruption)

	return eruption

func return_eruption(eruption_: Eruption):
	eruption_.visible = false
	eruption_pool.append(eruption_)

func burst_eruption():
	fill_trials()
	total_eruptions = min(tokens.size(), trials.size())
	var step = Catalog.VOLCANO_BURST_DURATION / float(total_eruptions)
	apply_shake_effect()

	for _i in range(total_eruptions):
		await get_tree().create_timer(step).timeout
		spawn_eruption(_i)
	
	#tokens.clear()
	#trials.clear()

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

	var eruption = get_eruption()

	var trial = trials[index_]
	var token = tokens[index_]

	eruption.reset(token, trial)
	eruption.call_deferred("activate")

func apply_shake_effect():
	var camera_tween = get_tree().create_tween()
	var time = Catalog.VOLCANO_BURST_DURATION + Catalog.ERUPTION_DURATION
	camera_tween.tween_method(start_camera_shake, 5.0, 1.0, time)

func start_camera_shake(intensity_: float):
	var camera_offset = camera_shake_noise.get_noise_2d(randf_range(0.0, 100.0), Time.get_ticks_msec() * 0.001) * intensity_
	camera_2d.offset.x = camera_offset
	camera_2d.offset.y = camera_offset


#region splash
func prewarm_splash(count_: int):
	for i in count_:
		add_splash()

func get_splash() -> Splash:
	if splash_pool.is_empty():
		var splash = add_splash()
		return splash
	
	return splash_pool.pop_back()

func add_splash() -> Splash:
	var splash := splash_scene.instantiate() as Splash
	splash.visible = false
	splash.volcano = self
	%Splashs.add_child(splash)
	splash_pool.append(splash)
	return splash

func return_splash(splash_: Splash):
	splash_pool.append(splash_)

func burst_splash(progression_: Progression, count_: int) -> void:
	if count_ == 1:
		var splash = get_splash()
		splash.reset(progression_)
		return
	
	var step = (Catalog.DESIRE_DISSOLVE_DURATION - Catalog.SPASH_DURATION) / float(count_)

	for _i in range(count_):
		await get_tree().create_timer(step).timeout
		var splash = get_splash()
		splash.reset(progression_)
#endregion
