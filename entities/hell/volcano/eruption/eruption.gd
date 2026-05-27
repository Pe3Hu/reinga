class_name Eruption
extends Node2D


var volcano: Volcano
var sin_token: TokenSin
var trial: Trial

var start: Vector2
var end: Vector2
var control: Vector2

var t: float = 0.0
var active: bool = false

var trails: Array[Sprite2D]


func reset(token_: TokenSin, trial_: Trial, timeout_: float):
	sin_token = token_
	trial = trial_
	%ActivateTimer.wait_time = timeout_
	%ActivateTimer.start()
	
	t = 0.0

func update_vectors() -> void:
	start = sin_token.global_position
	var trial_token = trial.claim.sin_to_token[sin_token.type]
	end = trial_token.global_position
	
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
	t += delta_ / Catalog.ERUPTION_DURATION
	var time = clamp(t, 0, 1)

	global_position = bezier(start, control, end, time)
	
	if get_tree().get_frame() % 1 == 0:
		if not volcano.trail_pool.is_empty():
			var sprite = volcano.trail_pool.pop_front()
			sprite.global_position = global_position + sprite.texture.get_size() / 2
			sprite.modulate = modulate
			trails.append(sprite)
			sprite.visible = true
			
			var fading_tween = get_tree().create_tween()
			fading_tween.tween_method(
				func(value: float) -> void: sprite.modulate.a = value,
				0.6,
				0.0,
				Catalog.TRAIL_DURATION
			)
			
			await fading_tween.finished
			volcano.trail_pool.append(sprite)

	if time >= 1.0:
		deactivate()

func deactivate() -> void:
	if !active: return
	active = false
	visible = false

	volcano.return_eruption(self)
	
	if trial:
		var trial_token = trial.claim.sin_to_token[sin_token.type]
		trial_token.value -= 1
		#if trial_token.value < 0:
		#	volcano.check_sin(sin_token.type)
		volcano.single_splash(trial.tribute.progression)
	
	for trail in trails:
		trail.visible = false

func activate() -> void:
	if active: return
	active = true
	visible = true

	update_vectors()

	global_position = start

	var mid = (start + end) * 0.5
	var dir = (end - start).normalized()
	var perp = Vector2(-dir.y, dir.x)

	control = mid + perp * randf_range(-180, 180)

	if sin_token:
		modulate = Catalog.sin_to_color[sin_token.type]
		sin_token.value -= 1

func bezier(a_: Vector2, b_: Vector2, c_: Vector2, t_: float):
	var ab = a_.lerp(b_, t_)
	var bc = b_.lerp(c_, t_)
	return ab.lerp(bc, t_)


func _on_activate_timer_timeout() -> void:
	activate()
