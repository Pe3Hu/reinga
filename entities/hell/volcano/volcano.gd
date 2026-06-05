class_name Volcano
extends Node


var flow: FlowData

@export var eruption_scene: PackedScene
@export var splash_scene: PackedScene
@export var pressure_scene: PackedScene

@export var hell: Hell

var eruption_pool: Array[Eruption]
var splash_pool: Array[Splash]
var trail_pool: Array[Sprite2D]
var pressure_pool: Array[Sprite2D]

@export var camera_2d: Camera2D

var camera_shake_noise: FastNoiseLite = FastNoiseLite.new()


func _ready() -> void:
	prewarm_eruption(Catalog.DEFAULT_ERUPTION_COUNT)
	prewarm_splash(Catalog.DEFAULT_SPLASH_COUNT)
	setup_trail_pool(Catalog.DEFAULT_TRAIL_COUNT)
	prewarm_pressure_pool(Catalog.DEFAULT_PRESSURE_COUNT)

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
		add_trial()

func add_trial() -> void:
	var newSprite: Sprite2D = Sprite2D.new()
	newSprite.texture = load("res://entities/ui/token/sin/sin.png")
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
	
	if Scope.phase == Bozo.Phase.DISBURSEMENT and eruption_pool.size() == Catalog.DEFAULT_ERUPTION_COUNT:
		hell.treasury.apply_phase_visiblity()
		Scope.next_phase()

func flow_contribution_update():
	if !hell.data.jail.table.active_cages.is_empty():
		flow = hell.data.jail.table.active_cages.back().contribution.flow
		flow.nightmare = hell.nightmare.data
		flow.init_contribution_eruptions()
		burst_eruption()
	else:
		pass

func flow_plaza_update() -> void:
	if !hell.data.jail.plaza.type_to_faction.keys().is_empty():
		flow = hell.data.jail.plaza.flow
		flow.init_plaza_eruptions()
		burst_eruption()

func burst_eruption():
	if !flow: return
	if flow.eruptions.is_empty(): return
	var step = Catalog.VOLCANO_BURST_DURATION / float(flow.eruptions.size())
	if flow.contribution:
		apply_shake_effect()

	for _i in range(flow.eruptions.size()-1, -1, -1):
		var eruption = spawn_eruption(_i, step * (_i + 1))
		flow.eruptions.erase(eruption.data)

func spawn_eruption(index_: int, timeout_: float) -> Eruption:
	var eruption_data = flow.eruptions[index_]
	var eruption = get_eruption()
	eruption.reset(eruption_data, timeout_)
	return eruption
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

func burst_splash(progression_: Progression, count_: int, sign_: int = 1) -> void:
	var step = (Catalog.DESIRE_DISSOLVE_DURATION - Catalog.SPASH_DURATION) / float(count_)

	for _i in range(count_):
		await get_tree().create_timer(step).timeout
		var splash = get_splash()
		splash.reset(progression_, sign_)

func single_splash(progression_: Progression) -> void:
	var splash = get_splash()
	splash.reset(progression_)
#endregion

#region pressure
func prewarm_pressure_pool(count_: int) -> void:
	for i in count_:
		add_pressure()

func add_pressure() -> Pressure:
	var pressure = pressure_scene.instantiate() as Pressure
	pressure.volcano = self
	%Pressures.add_child(pressure)
	pressure_pool.append(pressure)
	return pressure

func get_pressure() -> Pressure:
	if pressure_pool.is_empty():
		var pressure = add_pressure()
		return pressure
	
	return pressure_pool.pop_back()
	
func return_pressure(pressure_: Pressure):
	pressure_.visible = false
	pressure_pool.append(pressure_)
#endregion

func deal_burst(deal_: Deal) -> void:
	var count = deal_.data.amber_data.value
	#var step = Catalog.DEAL_BURST_DURATION / float(count)
	var type = deal_.amber_token.data.type
	#print(count)
	
	for _i in count:
	#for _i in range(count-1, -1, -1):
		var eruption_data = EruptionData.new(flow, type, Bozo.Eruption.BANK)
		flow.eruptions.append(eruption_data)
	
	burst_deal_eruption()

func burst_deal_eruption():
	var step = Catalog.VOLCANO_BURST_DURATION / float(flow.eruptions.size())
	
	for i in range(flow.eruptions.size() - 1, -1, -1):
		var eruption = spawn_eruption(i, step * (i + 1))
		flow.eruptions.erase(eruption.data)

#func spawn_deal_eruption(type_: Bozo.Token, timeout_: float) -> void:
	#var eruption_data = EruptionData.new(flow, type_, Bozo.Eruption.BANK)
	#var eruption = get_eruption()
	#eruption.reset(eruption_data, timeout_)
