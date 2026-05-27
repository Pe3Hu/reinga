class_name Volcano
extends Node


var flow: FlowData = FlowData.new()

@export var eruption_scene: PackedScene
@export var splash_scene: PackedScene

@export var hell: Hell

var eruption_pool: Array[Eruption]
var splash_pool: Array[Splash]
var trail_pool: Array[Sprite2D]

@export var camera_2d: Camera2D

var camera_shake_noise: FastNoiseLite = FastNoiseLite.new()


func _ready() -> void:
	flow.nightmare = hell.nightmare.data
	prewarm_eruption(Catalog.DEFAULT_ERUPTION_COUNT)
	prewarm_splash(Catalog.DEFAULT_SPLASH_COUNT)
	setup_trail_pool(Catalog.DEFAULT_ERUPTION_COUNT * 10)

#region eruption
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

	if !eruption_pool.is_empty():
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
	#print(["return", eruption_pool.size(), eruption_fridge.size()])
	
	if Scope.phase == Bozo.Phase.DISBURSEMENT and eruption_pool.size() == Catalog.DEFAULT_ERUPTION_COUNT:
		Scope.in_progress = false
		Scope.next_phase()

func flow_update():
	flow.contribution = hell.jail.active_cage.contribution.data
	flow.init_eruptions()
	
func burst_eruption():
	var step = Catalog.VOLCANO_BURST_DURATION / float(flow.eruptions.size())
	apply_shake_effect()

	for _i in range(flow.eruptions.size()-1, -1, -1):
		spawn_eruption(_i, step * (_i + 1))

func spawn_eruption(index_: int, timeout_: float):
	var eruption_data = flow.eruptions[index_]
	var token = hell.jail.active_cage.contribution.get_token(eruption_data.sin_type)
	var trial = hell.nightmare.type_to_trial[eruption_data.trial_type]
	#print(["spawn", eruption_pool.size(), eruption_fridge.size()])
	var eruption = get_eruption()
	eruption.reset(token, trial, timeout_)
#endregion

#region shake
func apply_shake_effect():
	var camera_tween = get_tree().create_tween()
	var time = Catalog.VOLCANO_BURST_DURATION + Catalog.ERUPTION_DURATION
	camera_tween.tween_method(start_camera_shake, 5.0, 1.0, time)

func start_camera_shake(intensity_: float):
	var camera_offset = camera_shake_noise.get_noise_2d(randf_range(0.0, 100.0), Time.get_ticks_msec() * 0.001) * intensity_
	camera_2d.offset.x = camera_offset
	camera_2d.offset.y = camera_offset
#endregion

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
	var step = (Catalog.DESIRE_DISSOLVE_DURATION - Catalog.SPASH_DURATION) / float(count_)

	for _i in range(count_):
		await get_tree().create_timer(step).timeout
		var splash = get_splash()
		splash.reset(progression_)

func single_splash(progression_: Progression) -> void:
	var splash = get_splash()
	splash.reset(progression_)
#endregion
