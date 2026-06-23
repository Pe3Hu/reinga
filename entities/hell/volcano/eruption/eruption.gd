class_name Eruption
extends Node2D


var data: EruptionData
var volcano: Volcano
var start_token: Token
var end_token: Token
var end_target: Variant

var start: Vector2
var end: Vector2
var control: Vector2

var t: float = 0.0
var trail_timer: float = 0.0
var active: bool = false

var trails: Array[Sprite2D]


func reset(data_: EruptionData, timeout_: float):
	data = data_
	update_start_token()
	
	update_end_token()
	reset_timer(timeout_)


func update_start_token() -> void:
	if data.from_safe:
		var safe = volcano.hell.bank.active_safe
		if safe:
			start_token = safe.amber
		return
	
	var cage = volcano.hell.jail.get_active_cage()
	if cage:
		start_token = cage.contribution.get_token(data.token)
	else:
		var token_data = volcano.hell.data.jail.plaza.get_available_token(data.token)
		start_token = volcano.hell.jail.get_trait_token(token_data)

func update_end_token() -> void:
	if data.type == Bozo.Eruption.MARKET:
		end_target = volcano.hell.market
	elif data.type == Bozo.Eruption.BANK:
		end_target = volcano.hell.bank
		if Catalog.ambers.has(data.token):
			var market = volcano.hell.market
			start_token = market.type_to_amber[data.token]
	else:
		end_target = volcano.hell.nightmare.type_to_trial[data.type].claim
	
	if !start_token:
		active = true
		deactivate()
		print("eruption start_token bug")
		return
	
	var token_type = data.token if data.from_safe else start_token.data.type
	end_token = end_target.type_to_token[token_type]

func reset_timer(timeout_: float) -> void:
	if !start_token: return
	%ActivateTimer.stop()
	%ActivateTimer.wait_time = timeout_
	%ActivateTimer.start()
	t = 0.0

func update_vectors() -> void:
	start = start_token.global_position
	end = end_token.global_position
	
	var shift = Vector2.from_angle(randf() * PI * 2) * Catalog.ERUPTION_OFFSET_L
	start += shift
	global_position = start
	
	var mid = (start + end) * 0.5
	var dir = (end - start).normalized()
	var perp = Vector2(-dir.y, dir.x)

	control = mid + perp * randf_range(-180, 180)
	#end -= shift

func _process(delta_):
	if !active: return
	t += delta_ / Gear.eruptions[Gear.tempo]
	var time = clamp(t, 0, 1)
	trail_timer += delta_
	global_position = bezier(start, control, end, time)
	
	if trail_timer >= Gear.trail_intervals[Gear.tempo]:
		spawn_trail()

	if time >= 1.0:
		deactivate()

func spawn_trail() -> void:
	trail_timer = 0.0
	if not volcano.trail_pool.is_empty():
		var sprite = volcano.trail_pool.pop_front()
		sprite.global_position = global_position + sprite.texture.get_size() / 2
		sprite.modulate = modulate
		trails.append(sprite)
		sprite.visible = true
		
		if Catalog.sins.has(data.token):
			sprite.texture = load("res://entities/ui/token/sin/sin on.png")
		else:
			match data.token:
				Bozo.Posture.OBLIVION:
					sprite.texture = load("res://entities/ui/token/posture/images/oblivion.png")
				Bozo.Posture.MADNESS:
					sprite.texture = load("res://entities/ui/token/posture/images/madness.png")
		
		if start_token.data as AmberData:
			sprite.texture = load("res://entities/ui/token/amber/amber on.png")
		
		var fading_tween = get_tree().create_tween()
		fading_tween.tween_method(
			func(value: float) -> void: sprite.modulate.a = value,
			0.6,
			0.0,
			Gear.trails[Gear.tempo]
		)
		
		fading_tween.finished.connect(func():
			trails.erase(sprite)
			volcano.trail_pool.append(sprite)
		)

func deactivate() -> void:
	if !active: return
	active = false
	visible = false
	%ActivateTimer.stop()
	
	if end_token:
		var value = -1
		
		if (end_target as Bank) and (end_token as TokenAmber):
			value = 1
			#if start_token as TokenAmber:
				#pass
		
		end_token.data.value += value * Catalog.status_to_sign[data.status]
	
	if data.status == Bozo.Status.ON:
		if data.type != Bozo.Eruption.BANK and data.type != Bozo.Eruption.MARKET:
			volcano.single_splash(end_target.trial.tribute.progression)
	elif data.status == Bozo.Status.OFF:
		end_target.trial.tribute.data.calc_half()
	
	#for trail in trails:
	#	trail.visible = false
	#	volcano.trail_pool.append(trail)
	
	trails.clear()
	volcano.return_eruption(self)

func activate() -> void:
	if active: return
	active = true
	visible = true
	z_index = 1

	update_vectors()

	global_position = start

	var mid = (start + end) * 0.5
	var dir = (end - start).normalized()
	var perp = Vector2(-dir.y, dir.x)

	control = mid + perp * randf_range(-180, 180)

	if start_token:
		modulate = Catalog.token_to_color[start_token.data.type]
		var shift = -1
		
		if start_token.data as SinData:
			if start_token.data.trait_data:
				shift = 0
		
		start_token.data.value += shift
		
		if data.pressure.type != Bozo.Modifier.NONE:
			var pressure = volcano.get_pressure()
			pressure.eruption = self

func bezier(a_: Vector2, b_: Vector2, c_: Vector2, t_: float):
	var ab = a_.lerp(b_, t_)
	var bc = b_.lerp(c_, t_)
	return ab.lerp(bc, t_)

func _on_activate_timer_timeout() -> void:
	activate()
